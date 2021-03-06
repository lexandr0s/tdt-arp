/*
 * GPL
 * duckbox 2010
 */

/* ***************************** */
/* Includes                      */
/* ***************************** */

#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/socket.h>
#include <netdb.h>
#include <sys/types.h>
#include <dirent.h>
#include <errno.h>
#include <poll.h>

#include "playback.h"
#include "common.h"
#include "misc.h"

/* ***************************** */
/* Makros/Constants              */
/* ***************************** */

#define PLAYBACK_DEBUG

static short debug_level = 0;

static const char *FILENAME = "playback.c";
#ifdef PLAYBACK_DEBUG
#define playback_printf(level, fmt, x...) do { \
if (debug_level >= level) printf("[%s:%s] " fmt, FILENAME, __FUNCTION__, ## x); } while (0)
#else
#define playback_printf(level, fmt, x...)
#endif

#ifndef PLAYBACK_SILENT
#define playback_err(fmt, x...) do { printf("[%s:%s] " fmt, FILENAME, __FUNCTION__, ## x); } while (0)
#else
#define playback_err(fmt, x...)
#endif

#define cERR_PLAYBACK_NO_ERROR      0
#define cERR_PLAYBACK_ERROR        -1

#define cMaxSpeed_ff   128 /* fixme: revise */
#define cMaxSpeed_fr   -320 /* fixme: revise */

/* ***************************** */
/* Varaibles                     */
/* ***************************** */

static pthread_t supervisorThread;
static int hasThreadStarted = 0;

/* ***************************** */
/* Prototypes                    */
/* ***************************** */
static int PlaybackTerminate(Context_t  *context);

/* ***************************** */
/* MISC Functions                */
/* ***************************** */

/* **************************** */
/* Supervisor Thread            */
/* **************************** */

static void SupervisorThread(Context_t *context) {
	hasThreadStarted = 1;

	playback_printf(10, ">\n");

	while ( context && context->playback && context->playback->isPlaying && !(context->playback->abortRequested | context->playback->abortPlayback))
		usleep(100000);

	playback_printf(10, "<\n");

	hasThreadStarted = 2;
	PlaybackTerminate(context);

	playback_printf(0, "terminating\n");
	hasThreadStarted = 0;
}

/* ***************************** */
/* Functions                     */
/* ***************************** */

static int PlaybackStop(Context_t  *context);

static int PlaybackOpen(Context_t  *context, char * uri) {
    if (context->playback->isPlaying)
	PlaybackStop(context);

    playback_printf(10, "URI=%s\n", uri);

    if (context->playback->isPlaying) { // shouldn't happen
        playback_err("playback already running\n");
        return cERR_PLAYBACK_ERROR;
    }

    char * extension = NULL;

    context->playback->uri = strdup(uri);

    context->playback->isFile = 0;
    context->playback->isHttp = 0;

    if (!strncmp("file://", uri, 7) || !strncmp("myts://", uri, 7)) {
	    context->playback->isFile = 1;
            if (!strncmp("myts://", uri, 7)) {
                memcpy(context->playback->uri, "file", 4);
                context->playback->noprobe = 1;
            } else
                context->playback->noprobe = 0;

            extension = getExtension(context->playback->uri+7);
            if(!extension)
                return cERR_PLAYBACK_ERROR;

            //CHECK FOR SUBTITLES
            if (context->container && context->container->textSrtContainer)
                context->container->textSrtContainer->Command(context, CONTAINER_INIT, context->playback->uri+7);

            if (context->container && context->container->textSsaContainer)
                context->container->textSsaContainer->Command(context, CONTAINER_INIT, context->playback->uri+7);

            if (context->container && context->container->assContainer)
                context->container->assContainer->Command(context, CONTAINER_INIT, NULL);

    } else if (strstr(uri, "://")) {
            context->playback->isHttp = 1;
	    extension = "mp3";
            if (!strncmp("mms://", uri, 6)) {
                // mms is in reality called rtsp, and ffmpeg expects this
                char * tUri = (char*)malloc(strlen(uri) + 2);
                strncpy(tUri+1, uri, strlen(uri)+1);
                strncpy(tUri, "rtsp", 4);
                free(context->playback->uri);
                context->playback->uri = tUri;
            }
    } else {
	playback_err("Unknown stream (%s)\n", uri);
	return cERR_PLAYBACK_ERROR;
    }

    if ((context->container->Command(context, CONTAINER_ADD, extension) < 0)
    ||  (!context->container->selectedContainer)
    ||  (context->container->selectedContainer->Command(context, CONTAINER_INIT, context->playback->uri) < 0))
	return cERR_PLAYBACK_ERROR;

    playback_printf(10, "exiting with value 0\n");

    return cERR_PLAYBACK_NO_ERROR;
}

static int PlaybackClose(Context_t  *context) {
    int ret = cERR_PLAYBACK_NO_ERROR;

    playback_printf(10, "\n");

    if (context->container->Command(context, CONTAINER_DEL, NULL) < 0)
    {
        playback_err("container delete failed\n");
    }

    if (context->container && context->container->textSrtContainer)
        context->container->textSrtContainer->Command(context, CONTAINER_DEL, NULL);

    if (context->container && context->container->textSsaContainer)
        context->container->textSsaContainer->Command(context, CONTAINER_DEL, NULL);

    context->manager->audio->Command(context, MANAGER_DEL, NULL);
    context->manager->video->Command(context, MANAGER_DEL, NULL);
    context->manager->subtitle->Command(context, MANAGER_DEL, NULL);
    context->manager->dvbsubtitle->Command(context, MANAGER_DEL, NULL);
    context->manager->teletext->Command(context, MANAGER_DEL, NULL);

    context->playback->isPaused     = 0;
    context->playback->isPlaying    = 0;
    context->playback->isForwarding = 0;
    context->playback->BackWard     = 0;
    context->playback->SlowMotion   = 0;
    context->playback->Speed        = 0;
    if(context->playback->uri) {
        free(context->playback->uri);
        context->playback->uri = NULL;
    }

    playback_printf(10, "exiting with value %d\n", ret);

    return ret;
}

static int PlaybackPlay(Context_t  *context) {
    pthread_attr_t attr;
    int ret = cERR_PLAYBACK_NO_ERROR;

    playback_printf(10, "\n");

    if (!context->playback->isPlaying) {
        context->playback->AVSync = 1;
        context->output->Command(context, OUTPUT_AVSYNC, NULL);

        context->playback->isCreationPhase = 1;	// allows the created thread to go into wait mode
        ret = context->output->Command(context, OUTPUT_PLAY, NULL);

        if (ret != 0) {
            playback_err("OUTPUT_PLAY failed!\n");
            playback_err("clearing isCreationPhase!\n");

            context->playback->isCreationPhase = 0;	// allow thread to go into next state
            context->playback->isPlaying       = 0;
            context->playback->isPaused        = 0;
            context->playback->isForwarding    = 0;
            context->playback->BackWard        = 0;
            context->playback->SlowMotion      = 0;
            context->playback->Speed           = 0;
            context->container->selectedContainer->Command(context, CONTAINER_STOP, NULL);
        } else {
            context->playback->isPlaying    = 1;
            context->playback->isPaused     = 0;
            context->playback->isForwarding = 0;
            context->playback->BackWard     = 0;
            context->playback->SlowMotion   = 0;
            context->playback->Speed        = 1;

            if (hasThreadStarted == 0) {
                int error;
                pthread_attr_init(&attr);
                pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);

                if((error = pthread_create(&supervisorThread, &attr, (void *)&SupervisorThread, context)) != 0) 
                {
                    playback_printf(10, "Error creating thread, error:%d:%s\n", error,strerror(error));
                    ret = cERR_PLAYBACK_ERROR;
                }
                else 
                {
                    playback_printf(10, "Created thread\n");
                }
            }

            playback_printf(10, "clearing isCreationPhase!\n");

            context->playback->isCreationPhase = 0;	// allow thread to go into next state

            ret = context->container->selectedContainer->Command(context, CONTAINER_PLAY, NULL);
            if (ret != 0) {
                playback_err("CONTAINER_PLAY failed!\n");
            }

        }

    } else
    {
        playback_err("playback already running\n");
        ret = cERR_PLAYBACK_ERROR;
    }

    playback_printf(10, "exiting with value %d\n", ret);

    return ret;
}

static int PlaybackPause(Context_t  *context) {
    int ret = cERR_PLAYBACK_NO_ERROR;

    playback_printf(10, "\n");

    if (context->playback->isPlaying && !context->playback->isPaused) {

        if(context->playback->SlowMotion)
            context->output->Command(context, OUTPUT_CLEAR, NULL);

        context->output->Command(context, OUTPUT_PAUSE, NULL);

        context->playback->isPaused     = 1;
        //context->playback->isPlaying  = 1;
        context->playback->isForwarding = 0;
        context->playback->BackWard     = 0;
        context->playback->SlowMotion   = 0;
        context->playback->Speed        = 1;
    } else
    {
        playback_err("playback not playing or already in pause mode\n");
        ret = cERR_PLAYBACK_ERROR;
    }

    playback_printf(10, "exiting with value %d\n", ret);

    return ret;
}

static int PlaybackContinue(Context_t  *context) {
    int ret = cERR_PLAYBACK_NO_ERROR;

    playback_printf(10, "\n");

    if (context->playback->isPlaying &&
            (context->playback->isPaused || context->playback->isForwarding || context->playback->BackWard || context->playback->SlowMotion)) {

        if(context->playback->SlowMotion)
            context->output->Command(context, OUTPUT_CLEAR, NULL);

        context->output->Command(context, OUTPUT_CONTINUE, NULL);

        context->playback->isPaused     = 0;
        //context->playback->isPlaying  = 1;
        context->playback->isForwarding = 0;
        context->playback->BackWard     = 0;
        context->playback->SlowMotion   = 0;
        context->playback->Speed        = 1;
    } else
    {
        playback_err("continue not possible\n");
        ret = cERR_PLAYBACK_ERROR;
    }

    playback_printf(10, "exiting with value %d\n", ret);

    return ret;
}

static int PlaybackStop(Context_t  *context) {
    int ret = cERR_PLAYBACK_NO_ERROR;
    int wait_time = 20;

    playback_printf(10, "\n");

    if (context && context->playback && context->playback->isPlaying) {

        context->playback->isPaused     = 0;
        context->playback->isPlaying    = 0;
        context->playback->isForwarding = 0;
        context->playback->BackWard     = 0;
        context->playback->SlowMotion   = 0;
        context->playback->Speed        = 0;

        context->output->Command(context, OUTPUT_STOP, NULL);
        context->container->selectedContainer->Command(context, CONTAINER_STOP, NULL);

    } else
    {
        playback_err("stop not possible\n");
        ret = cERR_PLAYBACK_ERROR;
    }

    while ( (hasThreadStarted == 1) && (--wait_time) > 0 ) {
        playback_printf(10, "Waiting for supervisor thread to terminate itself, will try another %d times\n", wait_time);

        usleep(100000);
    }

    if (wait_time == 0) {
        playback_err( "Timeout waiting for thread!\n");

        ret = cERR_PLAYBACK_ERROR;
    }

    playback_printf(10, "exiting with value %d\n", ret);

    return ret;
}

static int PlaybackTerminate(Context_t  *context) {
    int ret = cERR_PLAYBACK_NO_ERROR;
    int wait_time = 20;

    playback_printf(20, "\n");

    if ( context && context->playback && context->playback->isPlaying ) {
        //First Flush and than delete container, else e2 cant read length of file anymore

        if (context->output->Command(context, OUTPUT_FLUSH, NULL) < 0)
        {
            playback_err("failed to flush output.\n");
        }

        ret = context->container->selectedContainer->Command(context, CONTAINER_STOP, NULL);

        context->playback->isPaused     = 0;
        context->playback->isPlaying    = 0;
        context->playback->isForwarding = 0;
        context->playback->BackWard     = 0;
        context->playback->SlowMotion   = 0;
        context->playback->Speed        = 0;

    } else
    {
        playback_err("%p %p %d\n", context, context->playback, context->playback->isPlaying);

        /* fixme: konfetti: we should return an error here but this seems to be a condition which
         * can happen and is not a real error, which leads to a dead neutrino. should investigate
         * here later.
         */
    }

    while ( (hasThreadStarted == 1) && (--wait_time) > 0 ) {
        playback_printf(10, "Waiting for supervisor thread to terminate itself, will try another %d times\n", wait_time);

        usleep(100000);
    }

    if (wait_time == 0) {
        playback_err( "Timeout waiting for thread!\n");

        ret = cERR_PLAYBACK_ERROR;
    }

    playback_printf(20, "exiting with value %d\n", ret);

    return ret;
}

static int PlaybackFastForward(Context_t  *context, int* speed) {
    int ret = cERR_PLAYBACK_NO_ERROR;

    playback_printf(10, "speed %d\n", *speed);

    /* Audio only forwarding not supported */
    if (context->playback->isVideo && !context->playback->isHttp && !context->playback->BackWard && (!context->playback->isPaused || context->playback->isPlaying)) {

        if ((*speed <= 0) || (*speed > cMaxSpeed_ff))
        {
            playback_err("speed %d out of range (1 - %d) \n", *speed, cMaxSpeed_ff);
            return cERR_PLAYBACK_ERROR;
        }

        context->playback->isForwarding = 1;
        context->playback->Speed = *speed;

        playback_printf(20, "Speed: %d x {%d}\n", *speed, context->playback->Speed);

        context->output->Command(context, OUTPUT_FASTFORWARD, NULL);
    } else
    {
        playback_err("fast forward not possible\n");
        ret = cERR_PLAYBACK_ERROR;
    }

    playback_printf(10, "exiting with value %d\n", ret);

    return ret;
}

static int PlaybackFastBackward(Context_t  *context,int* speed) {
    int ret = cERR_PLAYBACK_NO_ERROR;

    playback_printf(10, "speed = %d\n", *speed);

    /* Audio only reverse play not supported */
    if (context->playback->isVideo && !context->playback->isForwarding && (!context->playback->isPaused || context->playback->isPlaying)) {

        if ((*speed > 0) || (*speed < cMaxSpeed_fr))
        {
            playback_err("speed %d out of range (0 - %d) \n", *speed, cMaxSpeed_fr);
            return cERR_PLAYBACK_ERROR;
        }

        if (*speed == 0)
        {
            context->playback->BackWard = 0;
            context->playback->Speed = 0;    /* reverse end */
        } else
        {
            context->playback->isSeeking = 1;
            context->playback->Speed = *speed;
            context->playback->BackWard = 2^(*speed);
         
            playback_printf(1, "S %d B %f\n", context->playback->Speed, context->playback->BackWard);
        }

        context->output->Command(context, OUTPUT_AUDIOMUTE, "1");
        context->output->Command(context, OUTPUT_CLEAR, NULL);
        if (context->output->Command(context, OUTPUT_REVERSE, NULL) < 0)
        {
            playback_err("OUTPUT_REVERSE failed\n");
            context->playback->BackWard = 0;
            context->playback->Speed = 1;
            context->playback->isSeeking = 0;
            ret = cERR_PLAYBACK_ERROR;
        }
    } else
    {
        playback_err("fast backward not possible\n");
        ret = cERR_PLAYBACK_ERROR;
    }

    context->playback->isSeeking = 0;
    playback_printf(10, "exiting with value %d\n", ret);

    return ret;
}

static int PlaybackSlowMotion(Context_t  *context,int* speed) {
    int ret = cERR_PLAYBACK_NO_ERROR;

    playback_printf(10, "\n");

    //Audio only forwarding not supported
    if (context->playback->isVideo && !context->playback->isHttp && context->playback->isPlaying) {
        if(context->playback->isPaused)
            PlaybackContinue(context);

        switch(*speed) {
        case 2:
            context->playback->SlowMotion = 2;
            break;
        case 4:
            context->playback->SlowMotion = 4;
            break;
        case 8:
            context->playback->SlowMotion = 8;
            break;
        }

        playback_printf(20, "SlowMotion: %d x {%d}\n", *speed, context->playback->SlowMotion);

        context->output->Command(context, OUTPUT_SLOWMOTION, NULL);
    } else
    {
        playback_err("slowmotion not possible\n");
        ret = cERR_PLAYBACK_ERROR;
    }

    playback_printf(10, "exiting with value %d\n", ret);

    return ret;
}

static int PlaybackSeek(Context_t  *context, float * pos, int absolute) {
    int ret = cERR_PLAYBACK_NO_ERROR;

    playback_printf(10, "pos: %f\n", *pos);

    if (context->playback->isPlaying && !context->playback->isForwarding && !context->playback->BackWard && !context->playback->SlowMotion && !context->playback->isPaused) {
        context->playback->isSeeking = 1;

        context->output->Command(context, OUTPUT_CLEAR, NULL);

	if (absolute)
        	context->container->selectedContainer->Command(context, CONTAINER_SEEK_ABS, pos);
	else
        	context->container->selectedContainer->Command(context, CONTAINER_SEEK, pos);

        context->playback->isSeeking = 0;

    } else
    {
        playback_err("not possible\n");
        ret = cERR_PLAYBACK_ERROR;
    }

    playback_printf(10, "exiting with value %d\n", ret);

    return ret;
}

static int PlaybackPts(Context_t  *context, unsigned long long int* pts) {
    int ret = cERR_PLAYBACK_NO_ERROR;

    playback_printf(20, "\n");

    *pts = 0;

    if (context->playback->isPlaying) {
        ret = context->output->Command(context, OUTPUT_PTS, pts);
    } else
    {
        playback_err("not possible\n");
        ret = cERR_PLAYBACK_ERROR;
    }

    playback_printf(20, "exiting with value %d\n", ret);

    return ret;
}

static int PlaybackGetFrameCount(Context_t  *context, unsigned long long int* frameCount) {
    int ret = cERR_PLAYBACK_NO_ERROR;

    playback_printf(20, "\n");

    *frameCount = 0;

    if (context->playback->isPlaying) {
        ret = context->output->Command(context, OUTPUT_GET_FRAME_COUNT, frameCount);
    } else
    {
        playback_err("not possible\n");
        ret = cERR_PLAYBACK_ERROR;
    }

    playback_printf(20, "exiting with value %d\n", ret);

    return ret;
}

static int PlaybackLength(Context_t  *context, double* length) {
    int ret = cERR_PLAYBACK_NO_ERROR;

    playback_printf(20, "\n");

    *length = -1;

    if (context->playback->isPlaying) {
        if (context->container && context->container->selectedContainer)
            context->container->selectedContainer->Command(context, CONTAINER_LENGTH, length);
    } else
    {
        playback_err("not possible\n");
        ret = cERR_PLAYBACK_ERROR;
    }

    playback_printf(20, "exiting with value %d\n", ret);

    return ret;
}

static int PlaybackSwitchAudio(Context_t  *context, int* track) {
    int ret = cERR_PLAYBACK_NO_ERROR;
    int curtrackid = 0;
    int nextrackid = 0;

    playback_printf(10, "\n");

    if (context->playback->isPlaying) {
        if (context->manager && context->manager->audio) {
            context->manager->audio->Command(context, MANAGER_GET, &curtrackid);
            context->manager->audio->Command(context, MANAGER_SET, track);
            context->manager->audio->Command(context, MANAGER_GET, &nextrackid);
        }

        if(nextrackid != curtrackid) {

            //PlaybackPause(context);

            if (context->output && context->output->audio)
                context->output->audio->Command(context, OUTPUT_SWITCH, (void*)"audio");

            if (context->container && context->container->selectedContainer)
                context->container->selectedContainer->Command(context, CONTAINER_SWITCH_AUDIO, &nextrackid);

            //PlaybackContinue(context);
        }
    } else
    {
        playback_err("switch audio not possible\n");
        ret = cERR_PLAYBACK_ERROR;
    }

    playback_printf(10, "exiting with value %d\n", ret);

    return ret;
}

static int PlaybackSwitchSubtitle(Context_t  *context, int* track) {
    int ret = cERR_PLAYBACK_NO_ERROR;

    playback_printf(10, "Track: %d\n", *track);

    if (context && context->playback && context->playback->isPlaying ) {
        if (context->manager && context->manager->subtitle) {
            int trackid;
            
            if (context->manager->subtitle->Command(context, MANAGER_SET, track) < 0)
            {
                playback_err("manager set track failed\n");
            }

            context->manager->subtitle->Command(context, MANAGER_GET, &trackid);

/* konfetti: I make this hack a little bit nicer,
 * but its still a hack in my opinion ;)
 */
            if (context->container && context->container->assContainer)
                context->container->assContainer->Command(context, CONTAINER_SWITCH_SUBTITLE, &trackid);

            if (trackid >= TEXTSRTOFFSET)
            {
                if (context->container && context->container->textSrtContainer)
                     context->container->textSrtContainer->Command(context, CONTAINER_SWITCH_SUBTITLE, &trackid);
            }
            if (trackid >= TEXTSSAOFFSET)
            {
                 if (context->container && context->container->textSsaContainer)
                     context->container->textSsaContainer->Command(context, CONTAINER_SWITCH_SUBTITLE, &trackid);
            }
            
            
            
        } else
        {
            ret = cERR_PLAYBACK_ERROR;
            playback_err("no subtitle\n");
        }
    } else
    {
        playback_err("not possible\n");
        ret = cERR_PLAYBACK_ERROR;
    }

    playback_printf(10, "exiting with value %d\n", ret);

    return ret;
}

static int PlaybackSwitchDVBSubtitle(Context_t  *context, int* pid) {
    int ret = cERR_PLAYBACK_NO_ERROR;

    playback_printf(10, "Track: %d\n", *pid);

    if (context && context->manager && context->manager->dvbsubtitle ) {
        if (context->manager->dvbsubtitle->Command(context, *pid < 0 ? MANAGER_DEL : MANAGER_SET, pid) < 0) {
                playback_err("dvbsub manager set track failed\n");
         	ret = cERR_PLAYBACK_ERROR;
        }
    } else
        playback_err("no dvbsubtitle\n");

    if (*pid < 0)
	container_ffmpeg_update_tracks(context, context->playback->uri, 0);

    playback_printf(10, "exiting with value %d\n", ret);

    return ret;
}

static int PlaybackSwitchTeletext(Context_t  *context, int* pid) {
    int ret = cERR_PLAYBACK_NO_ERROR;

    playback_printf(10, "Track: %d\n", *pid);

    if (context && context->manager && context->manager->teletext ) {
        if (context->manager->teletext->Command(context, *pid < 0 ? MANAGER_DEL : MANAGER_SET, pid)) {
                playback_err("ttxsub manager set track failed\n");
         	ret = cERR_PLAYBACK_ERROR;
	}
    } else
        playback_err("no ttxsubtitle\n");

    if (*pid < 0)
	container_ffmpeg_update_tracks(context, context->playback->uri, 0);

    playback_printf(10, "exiting with value %d\n", ret);

    return ret;
}

static int PlaybackInfo(Context_t  *context, char** infoString) {
    int ret = cERR_PLAYBACK_NO_ERROR;

    playback_printf(10, "\n");

/* konfetti comment: 
 * removed if clause here (playback running) because its 
 * not necessary for all container. e.g. in case of ffmpeg 
 * container playback must not play to get the info.
 */

    if (context->container && context->container->selectedContainer)
        context->container->selectedContainer->Command(context, CONTAINER_INFO, infoString);

    playback_printf(10, "exiting with value %d\n", ret);

    return ret;
}

static int Command(void* _context, PlaybackCmd_t command, void * argument) {
    Context_t* context = (Context_t*) _context; /* to satisfy compiler */
    int ret = cERR_PLAYBACK_NO_ERROR;

    playback_printf(20, "Command %d\n", command);


    switch(command) {
    case PLAYBACK_OPEN: {
        ret = PlaybackOpen(context, (char*)argument);
        break;
    }
    case PLAYBACK_CLOSE: {
        ret = PlaybackClose(context);
        break;
    }
    case PLAYBACK_PLAY: {
        ret = PlaybackPlay(context);
        break;
    }
    case PLAYBACK_STOP: {
        ret = PlaybackStop(context);
        break;
    }
    case PLAYBACK_PAUSE: {	// 4
        ret = PlaybackPause(context);
        break;
    }
    case PLAYBACK_CONTINUE: {
        ret = PlaybackContinue(context);
        break;
    }
    case PLAYBACK_TERM: {
        ret = PlaybackTerminate(context);
        break;
    }
    case PLAYBACK_FASTFORWARD: {
        ret = PlaybackFastForward(context,(int*)argument);
        break;
    }
    case PLAYBACK_SEEK: {
        ret = PlaybackSeek(context, (float*)argument, 0);
        break;
    }
    case PLAYBACK_SEEK_ABS: {
        ret = PlaybackSeek(context, (float*)argument, -1);
        break;
    }
    case PLAYBACK_PTS: { // 10
        ret = PlaybackPts(context, (unsigned long long int*)argument);
        break;
    }
    case PLAYBACK_LENGTH: { // 11
        ret = PlaybackLength(context, (double*)argument);
        break;
    }
    case PLAYBACK_SWITCH_AUDIO: {
        ret = PlaybackSwitchAudio(context, (int*)argument);
        break;
    }
    case PLAYBACK_SWITCH_SUBTITLE: {
        ret = PlaybackSwitchSubtitle(context, (int*)argument);
        break;
    }
    case PLAYBACK_INFO: {
        ret = PlaybackInfo(context, (char**)argument);
        break;
    }
    case PLAYBACK_SLOWMOTION: {
        ret = PlaybackSlowMotion(context,(int*)argument);
        break;
    }
    case PLAYBACK_FASTBACKWARD: {
        ret = PlaybackFastBackward(context,(int*)argument);
        break;
    }
    case PLAYBACK_GET_FRAME_COUNT: { // 10
        ret = PlaybackGetFrameCount(context, (unsigned long long int*)argument);
        break;
    }
    case PLAYBACK_SWITCH_DVBSUBTITLE: {
        ret = PlaybackSwitchDVBSubtitle(context, (int*)argument);
	break;
    }
    case PLAYBACK_SWITCH_TELETEXT: {
        ret = PlaybackSwitchTeletext(context, (int*)argument);
	break;
    }
    case PLAYBACK_FRAMEBUFFER_LOCK: {
        context->playback->mayWriteToFramebuffer = 0;
    	ret = cERR_PLAYBACK_NO_ERROR;
	break;
    }
    case PLAYBACK_FRAMEBUFFER_UNLOCK: {
        context->playback->mayWriteToFramebuffer = 1;
    	ret = cERR_PLAYBACK_NO_ERROR;
	break;
    }
    default:
        playback_err("PlaybackCmd %d not supported!\n", command);
        ret = cERR_PLAYBACK_ERROR;
        break;
    }

    playback_printf(20, "exiting with value %d\n", ret);

    return ret;
}


PlaybackHandler_t PlaybackHandler = {
    "Playback",
    -1,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    &Command,
    "",
    0,
    0
};

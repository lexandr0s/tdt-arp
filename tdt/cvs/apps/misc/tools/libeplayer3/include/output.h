#ifndef OUTPUT_H_
#define OUTPUT_H_

#include <stdio.h>
#include <stdint.h>

#include <libavutil/avutil.h>
#include <libavutil/time.h>
#include <libavformat/avformat.h>
#include <libswresample/swresample.h>
#include <libavutil/opt.h>

typedef enum {
    OUTPUT_INIT,
    OUTPUT_ADD,
    OUTPUT_DEL,
    OUTPUT_PLAY,
    OUTPUT_STOP,
    OUTPUT_PAUSE,
    OUTPUT_OPEN,
    OUTPUT_CLOSE,
    OUTPUT_FLUSH,
    OUTPUT_CONTINUE,
    OUTPUT_FASTFORWARD,
    OUTPUT_AVSYNC,
    OUTPUT_CLEAR,
    OUTPUT_PTS,
    OUTPUT_SWITCH,
    OUTPUT_SLOWMOTION,
    OUTPUT_AUDIOMUTE,
    OUTPUT_REVERSE,
    OUTPUT_DISCONTINUITY_REVERSE,
    OUTPUT_GET_FRAME_COUNT,
/* fixme: e2 */
    OUTPUT_SUBTITLE_REGISTER_FUNCTION = 222,
    OUTPUT_SUBTITLE_REGISTER_BUFFER = 223,
    OUTPUT_GET_SUBTITLE_OUTPUT,
    OUTPUT_SET_SUBTITLE_OUTPUT
} OutputCmd_t;

typedef enum {
    OUTPUT_TYPE_AUDIO,
    OUTPUT_TYPE_VIDEO,
    OUTPUT_TYPE_DVBSUBTITLE,
    OUTPUT_TYPE_TELETEXT
} OutputType_t;

typedef struct
{
     unsigned char*         data;
     unsigned int           len;

     unsigned char*         extradata;
     unsigned int           extralen;
     
     unsigned long long int pts;
     
     float                  frameRate;
     unsigned int           timeScale;
     
     unsigned int           width;
     unsigned int           height;
     
     OutputType_t           type;

     /* context from ffmpeg */
     AVFormatContext *avfc;
     /* stream from ffmpeg */
     AVStream *stream;
} AudioVideoOut_t;

struct Context_s;
typedef struct Context_s Context_t;

typedef struct Output_s {
    char * Name;
    int (* Command) (Context_t *, OutputCmd_t, void *);
    int (* Write) (Context_t *, void* privateData);
    char ** Capabilities;

} Output_t;

extern Output_t LinuxDvbOutput;
extern Output_t SubtitleOutput;
extern Output_t PipeOutput;

typedef struct OutputHandler_s {
    char * Name;
    Output_t * audio;
    Output_t * video;
    Output_t * subtitle;
    Output_t * dvbsubtitle;
    Output_t * teletext;
    int (* Command) (Context_t *, OutputCmd_t, void *);
} OutputHandler_t;

#endif

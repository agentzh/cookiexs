#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "INLINE.h"

#define COOKIE_LEN_LIMIT 1024 * 4

//static char *encode_hex_str(const char*, char **);
extern char** XS_unpack_charPtrPtr(SV* arg);
extern void XS_pack_charPtrPtr( SV* arg, char** array, int count);

char Buffer[COOKIE_LEN_LIMIT];

static int _decode_hex_str(const char*, char **);

SV* _parse_cookie(char* cs) {
    int i, value_flag;
    char* p;
    char* q;
    char* decode;
    AV *array;
    HV *hash;

    decode = (char *) malloc (COOKIE_LEN_LIMIT * sizeof(decode));
    if (decode == NULL) {
        croak("Cookie::XS::parse - Failed to malloc");
    }
    strncpy(Buffer, cs, COOKIE_LEN_LIMIT);
    Buffer[COOKIE_LEN_LIMIT-1] = '\0';
    hash = newHV();

    value_flag = 1;

    p = q = Buffer;
    while (*p) {
        if (*p=='=' && value_flag ){
            array = newAV();
            *p = 0; p++;
            _decode_hex_str(q, &decode);
            hv_store(hash, decode, strlen(decode), newRV_noinc((SV *)array), 0);
            q = p; value_flag = 0;
        } else if ( *p == ';' && *(p+1) == ' ') {
            *p = 0; p += 2;
            _decode_hex_str(q, &decode);
            av_push(array, newSVpvf("%s", decode));
            q = p; value_flag = 1;
        } else if ( *p == ';' || *p == '&' ) {
            *p = 0; p++;
            _decode_hex_str(q, &decode);
            av_push(array, newSVpvf("%s", decode));
            q = p;
        }
        p++;
    }
    _decode_hex_str(q, &decode);
    av_push(array, newSVpvf("%s", decode));
    if (decode) free(decode);
    return newRV_noinc((SV *) hash);
}

char *encode_hex_str(const char *str, char **out_buf)
{
    static const char *verbatim = "-_.*";
    static const char *hex = "0123456789ABCDEF";
    char *newstr = *out_buf;
    char *c;

    if (!str && !newstr)
        return NULL;

    for (c = newstr; *str; str++)
        if ((isalnum(*str) && !(*str & 0x80)) || strchr(verbatim, *str))
            *c++ = *str;
        else if (*str == ' ')
            *c++ = '+';
        else if (*str == '\n') {
            *c++ = '%';
            *c++ = '0';
            *c++ = 'D';
            *c++ = '%';
            *c++ = '0';
            *c++ = 'A';
        } else {
            *c++ = '%';
            *c++ = hex[(*str >> 4) & 15];
            *c++ = hex[*str & 15];
        }
    *c = 0;
    return newstr;
}

static int decode_hex_octet(const char *s)
{
    int hex_value;
    char *tail, hex[3];

    if (s && (hex[0] = s[0]) && (hex[1] = s[1])) {
        hex[2] = 0;
        hex_value = strtol(hex, &tail, 16);
        if (tail - hex == 2)
            return hex_value;
    }
    return -1;
}


int _decode_hex_str (const char *str, char **out)
{
    char *dest = *out;
    int i, val;

    memset(dest, 0, COOKIE_LEN_LIMIT);

    if (!str && ! dest)
        return 0;

    // most cases won't have hex octets 
    if (!strchr(str, '%')){
        strcpy(dest, str);
        return 1;
    }


    for (i = 0; str[i]; i++) {
        *dest++ = (str[i] == '%' && (val = decode_hex_octet(str+i+1)) >= 0) ?
        i+=2, val : str[i];
    }
    return 1;
}


MODULE = Cookie::XS	PACKAGE = Cookie::XS

PROTOTYPES: DISABLE


SV *
_parse_cookie (cs)
	char *	cs

int
_decode_hex_str (str, out)
	char *	str
	char **	out


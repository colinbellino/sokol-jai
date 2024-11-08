// TODO: generate this automatically

// ----------------------------------------

STBTT_MACSTYLE_DONTCARE :: 0;
STBTT_MACSTYLE_BOLD :: 1;
STBTT_MACSTYLE_ITALIC :: 2;
STBTT_MACSTYLE_UNDERSCORE :: 4;
STBTT_MACSTYLE_NONE :: 8;

// private structure
stbtt__buf :: struct {
    data:   *u8;
    cursor: s32;
    size:   s32;
}

//////////////////////////////////////////////////////////////////////////////
//
// TEXTURE BAKING API
//
// If you use this API, you only have to call two functions ever.
//
stbtt_bakedchar :: struct {
    x0:       u16; // coordinates of bbox in bitmap
    y0:       u16; // coordinates of bbox in bitmap
    x1:       u16; // coordinates of bbox in bitmap
    y1:       u16; // coordinates of bbox in bitmap
    xoff:     float;
    yoff:     float;
    xadvance: float;
}

// if return is positive, the first unused row of the bitmap
// if return is negative, returns the negative of the number of characters that fit
// if return is 0, no characters fit and no rows were used
// This uses a very crappy packing.
stbtt_aligned_quad :: struct {
    x0: float; // top-left
    y0: float; // top-left
    s0: float; // top-left
    t0: float; // top-left
    x1: float; // bottom-right
    y1: float; // bottom-right
    s1: float; // bottom-right
    t1: float; // bottom-right
}

//////////////////////////////////////////////////////////////////////////////
//
// NEW TEXTURE BAKING API
//
// This provides options for packing multiple fonts into one atlas, not
// perfectly but better than nothing.
stbtt_packedchar :: struct {
    x0:       u16; // coordinates of bbox in bitmap
    y0:       u16; // coordinates of bbox in bitmap
    x1:       u16; // coordinates of bbox in bitmap
    y1:       u16; // coordinates of bbox in bitmap
    xoff:     float;
    yoff:     float;
    xadvance: float;
    xoff2:    float;
    yoff2:    float;
}

// stbrp_rect :: struct {}

// Creates character bitmaps from the font_index'th font found in fontdata (use
// font_index=0 if you don't know what that is). It creates num_chars_in_range
// bitmaps for characters with unicode values starting at first_unicode_char_in_range
// and increasing. Data for how to render them is stored in chardata_for_range;
// pass these to stbtt_GetPackedQuad to get back renderable quads.
//
// font_size is the full height of the character from ascender to descender,
// as computed by stbtt_ScaleForPixelHeight. To use a point size as computed
// by stbtt_ScaleForMappingEmToPixels, wrap the point size in STBTT_POINT_SIZE()
// and pass that result as 'font_size':
//       ...,                  20 , ... // font max minus min y is 20 pixels tall
//       ..., STBTT_POINT_SIZE(20), ... // 'M' is 20 pixels tall
stbtt_pack_range :: struct {
    font_size:                        float;
    first_unicode_codepoint_in_range: s32; // if non-zero, then the chars are continuous, and this is the first codepoint
    array_of_unicode_codepoints:      *s32; // if non-zero, then this is an array of unicode codepoints
    num_chars:                        s32;
    chardata_for_range:               *stbtt_packedchar; // output
    h_oversample:                     u8; // don't set these, they're used internally
    v_oversample:                     u8; // don't set these, they're used internally
}

// this is an opaque structure that you shouldn't mess with which holds
// all the context needed from PackBegin to PackEnd.
stbtt_pack_context :: struct {
    user_allocator_context: *void;
    pack_info:              *void;
    width:                  s32;
    height:                 s32;
    stride_in_bytes:        s32;
    padding:                s32;
    skip_missing:           s32;
    h_oversample:           u32;
    v_oversample:           u32;
    pixels:                 *u8;
    nodes:                  *void;
}

// The following structure is defined publicly so you can declare one on
// the stack or as a global or etc, but you should treat it as opaque.
stbtt_fontinfo :: struct {
    userdata:         *void;
    data:             *u8; // pointer to .ttf file
    fontstart:        s32; // offset of start of font

    numGlyphs:        s32; // number of glyphs, needed for range checking

    loca:             s32; // table locations as offset from start of .ttf
    head:             s32; // table locations as offset from start of .ttf
    glyf:             s32; // table locations as offset from start of .ttf
    hhea:             s32; // table locations as offset from start of .ttf
    hmtx:             s32; // table locations as offset from start of .ttf
    kern:             s32; // table locations as offset from start of .ttf
    gpos:             s32; // table locations as offset from start of .ttf
    svg:              s32; // table locations as offset from start of .ttf
    index_map:        s32; // a cmap mapping for our chosen character encoding
    indexToLocFormat: s32; // format needed to map from glyph index to glyph

    cff:              stbtt__buf; // cff font data
    charstrings:      stbtt__buf; // the charstring index
    gsubrs:           stbtt__buf; // global charstring subroutines index
    subrs:            stbtt__buf; // private charstring subroutines index
    fontdicts:        stbtt__buf; // array of font dicts
    fdselect:         stbtt__buf; // map from glyph to fontdict
}

// as above, but takes one or more glyph indices for greater efficiency
stbtt_kerningentry :: struct {
    glyph1:  s32; // use stbtt_FindGlyphIndex
    glyph2:  s32;
    advance: s32;
}

STBTT :: enum u32 {
    vmove  :: 1;
    vline  :: 2;
    vcurve :: 3;
    vcubic :: 4;

    STBTT_vmove  :: vmove;
    STBTT_vline  :: vline;
    STBTT_vcurve :: vcurve;
    STBTT_vcubic :: vcubic;
}

stbtt_vertex :: struct {
    x:       s16;
    y:       s16;
    cx:      s16;
    cy:      s16;
    cx1:     s16;
    cy1:     s16;
    type:    u8;
    padding: u8;
}

// @TODO: don't expose this structure
stbtt__bitmap :: struct {
    w:      s32;
    h:      s32;
    stride: s32;
    pixels: *u8;
}


// returns the string (which may be big-endian double byte, e.g. for unicode)
// and puts the length in bytes in *length.
//
// some of the values for the IDs are below; for more see the truetype spec:
//     http://developer.apple.com/textfonts/TTRefMan/RM06/Chap6name.html
//     http://www.microsoft.com/typography/otspec/name.htm
STBTT_PLATFORM_ID :: enum u32 {
    UNICODE   :: 0;
    MAC       :: 1;
    ISO       :: 2;
    MICROSOFT :: 3;

    STBTT_PLATFORM_ID_UNICODE   :: UNICODE;
    STBTT_PLATFORM_ID_MAC       :: MAC;
    STBTT_PLATFORM_ID_ISO       :: ISO;
    STBTT_PLATFORM_ID_MICROSOFT :: MICROSOFT;
}

STBTT_UNICODE_EID :: enum u32 {
    UNICODE_1_0      :: 0;
    UNICODE_1_1      :: 1;
    ISO_10646        :: 2;
    UNICODE_2_0_BMP  :: 3;
    UNICODE_2_0_FULL :: 4;

    STBTT_UNICODE_EID_UNICODE_1_0      :: UNICODE_1_0;
    STBTT_UNICODE_EID_UNICODE_1_1      :: UNICODE_1_1;
    STBTT_UNICODE_EID_ISO_10646        :: ISO_10646;
    STBTT_UNICODE_EID_UNICODE_2_0_BMP  :: UNICODE_2_0_BMP;
    STBTT_UNICODE_EID_UNICODE_2_0_FULL :: UNICODE_2_0_FULL;
}

STBTT_MS_EID :: enum u32 {
    SYMBOL       :: 0;
    UNICODE_BMP  :: 1;
    SHIFTJIS     :: 2;
    UNICODE_FULL :: 10;

    STBTT_MS_EID_SYMBOL       :: SYMBOL;
    STBTT_MS_EID_UNICODE_BMP  :: UNICODE_BMP;
    STBTT_MS_EID_SHIFTJIS     :: SHIFTJIS;
    STBTT_MS_EID_UNICODE_FULL :: UNICODE_FULL;
}

STBTT_MAC_EID :: enum u32 {
    ROMAN        :: 0;
    ARABIC       :: 4;
    JAPANESE     :: 1;
    HEBREW       :: 5;
    CHINESE_TRAD :: 2;
    GREEK        :: 6;
    KOREAN       :: 3;
    RUSSIAN      :: 7;

    STBTT_MAC_EID_ROMAN        :: ROMAN;
    STBTT_MAC_EID_ARABIC       :: ARABIC;
    STBTT_MAC_EID_JAPANESE     :: JAPANESE;
    STBTT_MAC_EID_HEBREW       :: HEBREW;
    STBTT_MAC_EID_CHINESE_TRAD :: CHINESE_TRAD;
    STBTT_MAC_EID_GREEK        :: GREEK;
    STBTT_MAC_EID_KOREAN       :: KOREAN;
    STBTT_MAC_EID_RUSSIAN      :: RUSSIAN;
}

STBTT_MS_LANG :: enum u32 {
    ENGLISH  :: 1033;
    ITALIAN  :: 1040;
    CHINESE  :: 2052;
    JAPANESE :: 1041;
    DUTCH    :: 1043;
    KOREAN   :: 1042;
    FRENCH   :: 1036;
    RUSSIAN  :: 1049;
    GERMAN   :: 1031;
    SPANISH  :: 1033;
    HEBREW   :: 1037;
    SWEDISH  :: 1053;

    STBTT_MS_LANG_ENGLISH  :: ENGLISH;
    STBTT_MS_LANG_ITALIAN  :: ITALIAN;
    STBTT_MS_LANG_CHINESE  :: CHINESE;
    STBTT_MS_LANG_JAPANESE :: JAPANESE;
    STBTT_MS_LANG_DUTCH    :: DUTCH;
    STBTT_MS_LANG_KOREAN   :: KOREAN;
    STBTT_MS_LANG_FRENCH   :: FRENCH;
    STBTT_MS_LANG_RUSSIAN  :: RUSSIAN;
    STBTT_MS_LANG_GERMAN   :: GERMAN;
    STBTT_MS_LANG_SPANISH  :: SPANISH;
    STBTT_MS_LANG_HEBREW   :: HEBREW;
    STBTT_MS_LANG_SWEDISH  :: SWEDISH;
}

STBTT_MAC_LANG :: enum u32 {
    ENGLISH            :: 0;
    JAPANESE           :: 11;
    ARABIC             :: 12;
    KOREAN             :: 23;
    DUTCH              :: 4;
    RUSSIAN            :: 32;
    FRENCH             :: 1;
    SPANISH            :: 6;
    GERMAN             :: 2;
    SWEDISH            :: 5;
    HEBREW             :: 10;
    CHINESE_SIMPLIFIED :: 33;
    ITALIAN            :: 3;
    CHINESE_TRAD       :: 19;

    STBTT_MAC_LANG_ENGLISH            :: ENGLISH;
    STBTT_MAC_LANG_JAPANESE           :: JAPANESE;
    STBTT_MAC_LANG_ARABIC             :: ARABIC;
    STBTT_MAC_LANG_KOREAN             :: KOREAN;
    STBTT_MAC_LANG_DUTCH              :: DUTCH;
    STBTT_MAC_LANG_RUSSIAN            :: RUSSIAN;
    STBTT_MAC_LANG_FRENCH             :: FRENCH;
    STBTT_MAC_LANG_SPANISH            :: SPANISH;
    STBTT_MAC_LANG_GERMAN             :: GERMAN;
    STBTT_MAC_LANG_SWEDISH            :: SWEDISH;
    STBTT_MAC_LANG_HEBREW             :: HEBREW;
    STBTT_MAC_LANG_CHINESE_SIMPLIFIED :: CHINESE_SIMPLIFIED;
    STBTT_MAC_LANG_ITALIAN            :: ITALIAN;
    STBTT_MAC_LANG_CHINESE_TRAD       :: CHINESE_TRAD;
}
// ----------------------------------------

#module_parameters(DEBUG := false, USE_GL := false, USE_DLL := false);

#scope_export;

#if OS == .WINDOWS {
    #if USE_DLL {
        #if USE_GL {

            #if  DEBUG { sokol_fontstash_clib :: #library "sokol_fontstash_windows_x64_gl_debug";   }
            else       { sokol_fontstash_clib :: #library "sokol_fontstash_windows_x64_gl_release"; }
        } else {

            #if  DEBUG { sokol_fontstash_clib :: #library "sokol_fontstash_windows_x64_d3d11_debug";   }
            else       { sokol_fontstash_clib :: #library "sokol_fontstash_windows_x64_d3d11_release"; }
        }
    } else {
        #if USE_GL {

            #if  DEBUG { sokol_fontstash_clib :: #library,no_dll "sokol_fontstash_windows_x64_gl_debug";   }
            else       { sokol_fontstash_clib :: #library,no_dll "sokol_fontstash_windows_x64_gl_release"; }
        } else {

            #if  DEBUG { sokol_fontstash_clib :: #library,no_dll "sokol_fontstash_windows_x64_d3d11_debug";   }
            else       { sokol_fontstash_clib :: #library,no_dll "sokol_fontstash_windows_x64_d3d11_release"; }
        }
    }
}
else #if OS == .MACOS {
    #if USE_DLL {
             #if  USE_GL && CPU == .ARM64 &&  DEBUG { sokol_fontstash_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .ARM64 && !DEBUG { sokol_fontstash_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_release.dylib"; }
        else #if  USE_GL && CPU == .X64   &&  DEBUG { sokol_fontstash_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .X64   && !DEBUG { sokol_fontstash_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_release.dylib"; }
        else #if !USE_GL && CPU == .ARM64 &&  DEBUG { sokol_fontstash_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .ARM64 && !DEBUG { sokol_fontstash_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_release.dylib"; }
        else #if !USE_GL && CPU == .X64   &&  DEBUG { sokol_fontstash_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .X64   && !DEBUG { sokol_fontstash_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_release.dylib"; }
    } else {
        #if USE_GL {

            #if CPU == .ARM64 {
                #if  DEBUG { sokol_fontstash_clib :: #library,no_dll "sokol_fontstash_macos_arm64_gl_debug";   }
                else       { sokol_fontstash_clib :: #library,no_dll "sokol_fontstash_macos_arm64_gl_release"; }
            } else {
                #if  DEBUG { sokol_fontstash_clib :: #library,no_dll "sokol_fontstash_macos_x64_gl_debug";   }
                else       { sokol_fontstash_clib :: #library,no_dll "sokol_fontstash_macos_x64_gl_release"; }
            }
        } else {

            #if CPU == .ARM64 {
                #if  DEBUG { sokol_fontstash_clib :: #library,no_dll "sokol_fontstash_macos_arm64_metal_debug";   }
                else       { sokol_fontstash_clib :: #library,no_dll "sokol_fontstash_macos_arm64_metal_release"; }
            } else {
                #if  DEBUG { sokol_fontstash_clib :: #library,no_dll "sokol_fontstash_macos_x64_metal_debug";   }
                else       { sokol_fontstash_clib :: #library,no_dll "sokol_fontstash_macos_x64_metal_release"; }
            }
        }
    }
} else #if OS == .LINUX {
    #if  DEBUG { sokol_fontstash_clib :: #library,no_dll "sokol_fontstash_linux_x64_gl_debug";   }
    else       { sokol_fontstash_clib :: #library,no_dll "sokol_fontstash_linux_x64_gl_release"; }
} else {
    log_error("This OS is currently not supported");
}

sfons_allocator_t :: struct {
    alloc_fn : (a0: u64, a1: *void) -> *void #c_call;
    free_fn : (a0: *void, a1: *void) #c_call;
    user_data : *void;
}

sfons_desc_t :: struct {
    width:      s32;    // initial width of font atlas texture (default: 512, must be power of 2)
    height:     s32;   // initial height of font atlas texture (default: 512, must be power of 2)
    allocator:  sfons_allocator_t;    // optional memory allocation overrides
}

FONS_VERTEX_COUNT :: 1024;
FONS_MAX_STATES :: 20;
FONS_MAX_FALLBACKS :: 20;
FONS_HASH_LUT_SIZE :: 256;

FONSparams :: struct {
    width, height: s32;
    flags: u8;
    userPtr: *void;
    renderCreate: (uptr: *void, width: s32, height: s32) -> s32;
    renderResize: (uptr: *void, width: s32, height: s32) -> s32;
    renderUpdate: (uptr: *void, rect: *s32, data: *u8) -> void;
    renderDraw: (uptr: *void, verts: *float, tcoords: *float, colors: *s32, nverts: s32) -> void;
    renderDelete: (uptr: *void) -> void;
}

FONSglyph :: struct {
    codepoint: u32;
    index: s32;
    next: s32;
    size, blur: s16;
    x0,y0,x1,y1: s16;
    xadv,xoff,yoff: s16;
}

FONSttFontImpl :: struct {
    font: stbtt_fontinfo;
}

FONSfont :: struct {
    font: FONSttFontImpl;
    name: [64]u8;
    data: *u8;
    dataSize: s32;
    freeData: u8;
    ascender: float;
    descender: float;
    lineh: float;
    glyphs: *FONSglyph;
    cglyphs: s32;
    nglyphs: s32;
    lut: [FONS_HASH_LUT_SIZE]s32;
    fallbacks: [FONS_MAX_FALLBACKS]s32;
    nfallbacks: s32;
}

FONScontext :: struct {
    params: FONSparams;
    itw,ith: float;
    texData: *u8;
    dirtyRect: [4]s32;
    fonts: **FONSfont;
    atlas: *FONSatlas;
    cfonts: s32;
    nfonts: s32;
    verts: [FONS_VERTEX_COUNT*2]float;
    tcoords: [FONS_VERTEX_COUNT*2]float;
    colors: [FONS_VERTEX_COUNT]u32;
    nverts: s32;
    scratch: *u8;
    nscratch: s32;
    states: [FONS_MAX_STATES]FONSstate;
    nstates: s32;
    handleError: (uptr: *void, error: s32, val: s32) -> *void;
    errorUptr: *void;
}

FONSstate :: struct {
    font: s32;
    align: s32;
    size: float;
    color: u32;
    blur: float;
    spacing: float;
}

FONSatlasNode :: struct {
    x, y, width: s16;
}

FONSatlas :: struct
{
    width, height: s32;
    nodes: *FONSatlasNode;
    nnodes: s32;
    cnodes: s32;
}

using FONSalign :: enum {
    // Horizontal align
    FONS_ALIGN_LEFT 	:: 1<<0;	// Default
    FONS_ALIGN_CENTER 	:: 1<<1;
    FONS_ALIGN_RIGHT 	:: 1<<2;
    // Vertical align
    FONS_ALIGN_TOP 		:: 1<<3;
    FONS_ALIGN_MIDDLE	:: 1<<4;
    FONS_ALIGN_BOTTOM	:: 1<<5;
    FONS_ALIGN_BASELINE	:: 1<<6; // Default
}

FONS_INVALID :: -1;

sfons_create :: (desc: *sfons_desc_t) -> *FONScontext #foreign sokol_fontstash_clib;
sfons_destroy :: (ctx: *FONScontext) -> void  #foreign sokol_fontstash_clib;
sfons_flush :: (ctx: *FONScontext) -> void  #foreign sokol_fontstash_clib;
sfons_rgba :: (r: u8, g: u8, b: u8, a: u8) -> u32  #foreign sokol_fontstash_clib;

// Contructor and destructor.
fonsCreateInternal :: (params: *FONSparams) -> *FONScontext #foreign sokol_fontstash_clib;
fonsDeleteInternal :: (s: *FONScontext) -> void #foreign sokol_fontstash_clib;

fonsSetErrorCallback :: (s: *FONScontext, callback: #type (uptr: *void, error: s32, val: s32) -> void #c_call, uptr: *void) -> void #foreign sokol_fontstash_clib;

// Returns current atlas size.
fonsGetAtlasSize :: (s: *FONScontext, width: *s32, height: *s32) -> void #foreign sokol_fontstash_clib;

// Expands the atlas size.
fonsExpandAtlas :: (s: *FONScontext, width: s32, height: s32) -> s32 #foreign sokol_fontstash_clib;

// Resets the whole stash.
fonsResetAtlas :: (stash: *FONScontext, width: s32, height: s32) -> s32 #foreign sokol_fontstash_clib;

// Add fonts
fonsAddFont :: (s: *FONScontext, name: *u8, path: *u8) -> s32 #foreign sokol_fontstash_clib;
fonsAddFontMem :: (s: *FONScontext, name: *u8, data: *u8, ndata: s32, freeData: s32) -> s32 #foreign sokol_fontstash_clib;
fonsGetFontByName :: (s: *FONScontext, name: *u8) -> s32 #foreign sokol_fontstash_clib;
fonsAddFallbackFont :: (stash: *FONScontext, base: s32, fallback: s32) -> s32 #foreign sokol_fontstash_clib;

// State handling
fonsPushState :: (s: *FONScontext) -> void #foreign sokol_fontstash_clib;
fonsPopState :: (s: *FONScontext) -> void #foreign sokol_fontstash_clib;
fonsClearState :: (s: *FONScontext) -> void #foreign sokol_fontstash_clib;

// State setting
fonsSetSize :: (s: *FONScontext, size: float) -> void #foreign sokol_fontstash_clib;
fonsSetColor :: (s: *FONScontext, color: u32) -> void #foreign sokol_fontstash_clib;
fonsSetSpacing :: (s: *FONScontext, spacing: float) -> void #foreign sokol_fontstash_clib;
fonsSetBlur :: (s: *FONScontext, blur: float) -> void #foreign sokol_fontstash_clib;
fonsSetAlign :: (s: *FONScontext, align: s32) -> void #foreign sokol_fontstash_clib;
fonsSetFont :: (s: *FONScontext, font: s32) -> void #foreign sokol_fontstash_clib;

// Draw text
fonsDrawText :: (s: *FONScontext, x: float, y: float, _string: *u8, end: *u8) -> float #foreign sokol_fontstash_clib;

// Measure text
fonsTextBounds :: (s: *FONScontext, x: float, y: float, _string: *u8, end: *u8, bounds: *float) -> float #foreign sokol_fontstash_clib;
fonsLineBounds :: (s: *FONScontext, y: float, miny: *float, maxy: *float) -> void #foreign sokol_fontstash_clib;
fonsVertMetrics :: (s: *FONScontext, ascender: *float, descender: *float, lineh: *float) -> void #foreign sokol_fontstash_clib;

// Text iterator
// fonsTextIterInit :: (stash: *FONScontext, iter: *FONStextIter, x: float, y: float, str: *u8, end: *u8) -> s32 #foreign sokol_fontstash_clib;
// fonsTextIterNext :: (stash: *FONScontext, iter: *FONStextIter, quad: *FONSquad) -> s32 #foreign sokol_fontstash_clib;

// Pull texture changes
fonsGetTextureData :: (stash: *FONScontext, width: *s32, height: *s32) -> *u8 #foreign sokol_fontstash_clib;
fonsValidateTexture :: (s: *FONScontext, dirty: *s32) -> s32 #foreign sokol_fontstash_clib;

// Draws the stash texture for debugging
fonsDrawDebug :: (s: *FONScontext, x: float, y: float) -> void #foreign sokol_fontstash_clib;

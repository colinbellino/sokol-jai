// machine generated, do not edit

#module_parameters(DEBUG := false, USE_GL := false, USE_DLL := false);

#scope_export;

#if OS == .WINDOWS {
    #if USE_DLL {
        #if USE_GL {
            #system_library,link_always "ole32";
            #if  DEBUG { sokol_audio_clib :: #library "sokol_audio_windows_x64_gl_debug";   }
            else       { sokol_audio_clib :: #library "sokol_audio_windows_x64_gl_release"; }
        } else {
            #system_library,link_always "ole32";
            #if  DEBUG { sokol_audio_clib :: #library "sokol_audio_windows_x64_d3d11_debug";   }
            else       { sokol_audio_clib :: #library "sokol_audio_windows_x64_d3d11_release"; }
        }
    } else {
        #if USE_GL {
            #system_library,link_always "ole32";
            #if  DEBUG { sokol_audio_clib :: #library,no_dll "sokol_audio_windows_x64_gl_debug";   }
            else       { sokol_audio_clib :: #library,no_dll "sokol_audio_windows_x64_gl_release"; }
        } else {
            #system_library,link_always "ole32";
            #if  DEBUG { sokol_audio_clib :: #library,no_dll "sokol_audio_windows_x64_d3d11_debug";   }
            else       { sokol_audio_clib :: #library,no_dll "sokol_audio_windows_x64_d3d11_release"; }
        }
    }
}
else #if OS == .MACOS {
    #if USE_DLL {
             #if  USE_GL && CPU == .ARM64 &&  DEBUG { sokol_audio_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .ARM64 && !DEBUG { sokol_audio_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_release.dylib"; }
        else #if  USE_GL && CPU == .X64   &&  DEBUG { sokol_audio_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .X64   && !DEBUG { sokol_audio_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_release.dylib"; }
        else #if !USE_GL && CPU == .ARM64 &&  DEBUG { sokol_audio_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .ARM64 && !DEBUG { sokol_audio_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_release.dylib"; }
        else #if !USE_GL && CPU == .X64   &&  DEBUG { sokol_audio_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .X64   && !DEBUG { sokol_audio_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_release.dylib"; }
    } else {
        #if USE_GL {
            #system_library,link_always "AudioToolbox";
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_audio_clib :: #library,no_dll "sokol_audio_macos_arm64_gl_debug";   }
                else       { sokol_audio_clib :: #library,no_dll "sokol_audio_macos_arm64_gl_release"; }
            } else {
                #if  DEBUG { sokol_audio_clib :: #library,no_dll "sokol_audio_macos_x64_gl_debug";   }
                else       { sokol_audio_clib :: #library,no_dll "sokol_audio_macos_x64_gl_release"; }
            }
        } else {
            #system_library,link_always "AudioToolbox";
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_audio_clib :: #library,no_dll "sokol_audio_macos_arm64_metal_debug";   }
                else       { sokol_audio_clib :: #library,no_dll "sokol_audio_macos_arm64_metal_release"; }
            } else {
                #if  DEBUG { sokol_audio_clib :: #library,no_dll "sokol_audio_macos_x64_metal_debug";   }
                else       { sokol_audio_clib :: #library,no_dll "sokol_audio_macos_x64_metal_release"; }
            }
        }
    }
} else #if OS == .LINUX {
    #system_library,link_always "asound"; #system_library,link_always "dl"; #system_library,link_always "pthread";
    #if  DEBUG { sokol_audio_clib :: #library,no_dll "sokol_audio_linux_x64_gl_debug";   }
    else       { sokol_audio_clib :: #library,no_dll "sokol_audio_linux_x64_gl_release"; }
} else #if OS == .WASM {
    #if  DEBUG { sokol_audio_clib :: #library,no_dll "sokol_audio_wasm_gl_debug";   }
    else       { sokol_audio_clib :: #library,no_dll "sokol_audio_wasm_gl_release"; }
} else {
    log_error("This OS is currently not supported");
}

saudio_setup :: (desc: *saudio_desc) -> void #foreign sokol_audio_clib;
saudio_shutdown :: () -> void #foreign sokol_audio_clib;
saudio_isvalid :: () -> bool #foreign sokol_audio_clib;
saudio_userdata :: () -> *void #foreign sokol_audio_clib;
saudio_query_desc :: () -> saudio_desc #foreign sokol_audio_clib;
saudio_sample_rate :: () -> s32 #foreign sokol_audio_clib;
saudio_buffer_frames :: () -> s32 #foreign sokol_audio_clib;
saudio_channels :: () -> s32 #foreign sokol_audio_clib;
saudio_suspended :: () -> bool #foreign sokol_audio_clib;
saudio_expect :: () -> s32 #foreign sokol_audio_clib;
saudio_push :: (frames: *float, num_frames: s32) -> s32 #foreign sokol_audio_clib;

saudio_log_item :: enum u32 {
    OK;
    MALLOC_FAILED;
    ALSA_SND_PCM_OPEN_FAILED;
    ALSA_FLOAT_SAMPLES_NOT_SUPPORTED;
    ALSA_REQUESTED_BUFFER_SIZE_NOT_SUPPORTED;
    ALSA_REQUESTED_CHANNEL_COUNT_NOT_SUPPORTED;
    ALSA_SND_PCM_HW_PARAMS_SET_RATE_NEAR_FAILED;
    ALSA_SND_PCM_HW_PARAMS_FAILED;
    ALSA_PTHREAD_CREATE_FAILED;
    WASAPI_CREATE_EVENT_FAILED;
    WASAPI_CREATE_DEVICE_ENUMERATOR_FAILED;
    WASAPI_GET_DEFAULT_AUDIO_ENDPOINT_FAILED;
    WASAPI_DEVICE_ACTIVATE_FAILED;
    WASAPI_AUDIO_CLIENT_INITIALIZE_FAILED;
    WASAPI_AUDIO_CLIENT_GET_BUFFER_SIZE_FAILED;
    WASAPI_AUDIO_CLIENT_GET_SERVICE_FAILED;
    WASAPI_AUDIO_CLIENT_SET_EVENT_HANDLE_FAILED;
    WASAPI_CREATE_THREAD_FAILED;
    AAUDIO_STREAMBUILDER_OPEN_STREAM_FAILED;
    AAUDIO_PTHREAD_CREATE_FAILED;
    AAUDIO_RESTARTING_STREAM_AFTER_ERROR;
    USING_AAUDIO_BACKEND;
    AAUDIO_CREATE_STREAMBUILDER_FAILED;
    USING_SLES_BACKEND;
    SLES_CREATE_ENGINE_FAILED;
    SLES_ENGINE_GET_ENGINE_INTERFACE_FAILED;
    SLES_CREATE_OUTPUT_MIX_FAILED;
    SLES_MIXER_GET_VOLUME_INTERFACE_FAILED;
    SLES_ENGINE_CREATE_AUDIO_PLAYER_FAILED;
    SLES_PLAYER_GET_PLAY_INTERFACE_FAILED;
    SLES_PLAYER_GET_VOLUME_INTERFACE_FAILED;
    SLES_PLAYER_GET_BUFFERQUEUE_INTERFACE_FAILED;
    COREAUDIO_NEW_OUTPUT_FAILED;
    COREAUDIO_ALLOCATE_BUFFER_FAILED;
    COREAUDIO_START_FAILED;
    BACKEND_BUFFER_SIZE_ISNT_MULTIPLE_OF_PACKET_SIZE;
}

saudio_logger :: struct {
    func : (a0: *u8, a1: u32, a2: u32, a3: *u8, a4: u32, a5: *u8, a6: *void) #c_call;
    user_data : *void;
}

saudio_allocator :: struct {
    alloc_fn : (a0: u64, a1: *void) -> *void #c_call;
    free_fn : (a0: *void, a1: *void) #c_call;
    user_data : *void;
}

saudio_desc :: struct {
    sample_rate : s32;
    num_channels : s32;
    buffer_frames : s32;
    packet_frames : s32;
    num_packets : s32;
    stream_cb : (a0: *float, a1: s32, a2: s32) #c_call;
    stream_userdata_cb : (a0: *float, a1: s32, a2: s32, a3: *void) #c_call;
    user_data : *void;
    allocator : saudio_allocator;
    logger : saudio_logger;
}


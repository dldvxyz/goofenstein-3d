const std = @import("std");
const sdl = @cImport({
    @cInclude("SDL3/SDL.h");
});

pub fn main() anyerror!void {
    if (!sdl.SDL_Init(sdl.SDL_INIT_VIDEO)) {
        std.debug.print("SDL_Init failed: {s}\n", .{sdl.SDL_GetError()});
        return error.SDLInitFailed;
    }
    defer sdl.SDL_Quit();

    const window = sdl.SDL_CreateWindow("Goofenstein 3D™", 1280, 800, 0) orelse {
        std.debug.print("SDL_CreateWindow failed: {s}\n", .{sdl.SDL_GetError()});
        return error.WindowCreationFailed;
    };
    defer sdl.SDL_DestroyWindow(window);

    const renderer = sdl.SDL_CreateRenderer(window, null) orelse {
        std.debug.print("SDL_CreateRenderer failed: {s}\n", .{sdl.SDL_GetError()});
        return error.RendererCreationFailed;
    };
    defer sdl.SDL_DestroyRenderer(renderer);

    // Present on vsync so the loop doesn't spin the CPU at thousands of fps.
    sdl.SDL_SetRenderVSync(renderer, 1);

    var running = true;
    while (running) {
        var event: sdl.SDL_Event = undefined;
        while (sdl.SDL_PollEvent(&event)) {
            switch (event.type) {
                sdl.SDL_EVENT_QUIT => running = false,
                sdl.SDL_EVENT_KEY_DOWN => {
                    if (event.key.key == sdl.SDLK_ESCAPE) running = false;
                },
                else => {},
            }
        }

        sdl.SDL_SetRenderDrawColor(renderer, 0x06, 0x06, 0x06, 0xFF);
        sdl.SDL_RenderClear(renderer);
        sdl.SDL_RenderPresent(renderer);
    }
}

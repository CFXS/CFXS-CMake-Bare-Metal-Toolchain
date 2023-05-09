#pragma once
#include <cstdint>

#define __interrupt __attribute__((interrupt("irq")))
#define __weak      __attribute__((weak))
#define __c_func    extern "C"
#ifndef __used
    #define __used __attribute__((used))
#endif
#define __noinit         __attribute__((section(".noinit")))
#define __vector_table   __attribute__((section(".vector_table"), used))
#define __naked          __attribute__((naked))
#define __noreturn       __attribute__((noreturn))
#define __noinit         __attribute__((section(".noinit")))
#define __memory_barrier asm volatile("" ::: "memory")
#define __rw             volatile
#define __ro             const volatile

#define __mem8(x)    (*(__rw uint8_t*)(x))
#define __mem16(x)   (*(__rw uint16_t*)(x))
#define __mem32(x)   (*(__rw uint32_t*)(x))
#define __mem64(x)   (*(__rw uint64_t*)(x))
#define __memT(T, x) (*(__rw T*)(x))

#define __nv_mem8(x)    (*(uint8_t*)(x))
#define __nv_mem16(x)   (*(uint16_t*)(x))
#define __nv_mem32(x)   (*(uint32_t*)(x))
#define __nv_mem64(x)   (*(uint64_t*)(x))
#define __nv_memT(T, x) (*(T*)(x))
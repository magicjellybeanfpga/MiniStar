#include "gw1ns4c.h"

#define R8(addr)  (*(uint8_t *)(addr))
#define R16(addr) (*(uint16_t *)(addr))
#define R32(addr) (*(uint32_t *)(addr))

#define W8(addr, data)  (*(uint8_t *)(addr) = (data))
#define W16(addr, data) (*(uint16_t *)(addr) = (data))
#define W32(addr, data) (*(uint32_t *)(addr) = (data))

static const uint16_t colors[8] = {
    0x0000,
    0x001F,
    0x07FF,
    0x07E0,
    0xFFE0,
    0xFFFF,
    0xF81F,
    0xF800
};

static uint8_t cnt = 0;

int main()
{
    SysTick->LOAD = 81000000 / 6 - 1;
    SysTick->VAL = 0;
    SysTick->CTRL = SysTick_CTRL_CLKSOURCE_Msk | SysTick_CTRL_ENABLE_Msk;
    
    W32(0xA0001000, 0);
    W32(0xA0002000, 0);
    
    for (;;) {
        for (int i = 0; i < 6; ++i)
            while (!(SysTick->CTRL & SysTick_CTRL_COUNTFLAG_Msk));
        while (R32(0xA0002000) & (1 << 3));
        W32(0xA0002000, ((uint32_t)colors[cnt]) << 16U);
        cnt = (cnt + 1) % 8;
    }
}

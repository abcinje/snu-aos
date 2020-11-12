# wswd

### 끄적끄적 :memo:
- `leap/leap.c` : `sys_is_session_create()` 및 `sys_is_request()` 시스템 콜을 구현.
- `mm/page_io.c` : `leap/leap.c`에서 구현된 시스템 콜을 사용.
- `mm/memory.c` 및 `mm/swap_state.c` : 구현된 시스템 콜을 사용하지는 않음.

두 시스템 콜은 remote I/O와 관계된 것으로 보임.  
따라서 remote I/O 관련 기능을 걷어내기 위해 `mm/page_io.c`에서 시스템 콜이 어떻게(왜) 사용되고 있는지를 파악해야 할 것으로 생각됨.

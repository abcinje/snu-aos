# wswd

### 끄적끄적 :memo:
- `leap/leap.c` : `sys_is_session_create()` 및 `sys_is_request()` 시스템 콜을 구현.
- `mm/page_io.c` : `leap/leap.c`에서 구현된 `sys_is_request()` 시스템 콜을 사용.
- `mm/memory.c` 및 `mm/swap_state.c` : 구현된 시스템 콜을 사용하지는 않음.

두 시스템 콜은 remote I/O와 관계된 것으로 보임.  
따라서 remote I/O 관련 기능을 걷어내기 위해 `mm/page_io.c`에서 `sys_is_request()` 시스템 콜이 어떻게(왜) 사용되고 있는지를 파악해야 할 것으로 생각됨.  
(`sys_is_session_create()`는 커널 코드에서 호출되지는 않고, remote machine과 연결하기 위해 유저가 직접 호출.)

---

### sys_is_request()
```
int sys_is_request(struct page *page, int is_write);
```
- remote machine에 page 읽기 또는 쓰기 요청한다. (is_write가 0이면 read, 1이면 write)  
- 이 시스템 콜은 에러 발생 시 0이 아닌 값을 반환한다.  
- 쓰기 요청의 결과 에러가 발생했을 경우 `__swap_writepage()`를 호출해 page를 그냥 swap 영역에 기록.  
- 읽기 요청의 결과 에러가 발생했을 경우 page를 그냥 swap 영역에서 읽어옴.
- 이 연구에서는 frontswap은 아예 쓰지 않은 것으로 보인다.

---

### References
[1] [문c 블로그, Swap -2- (Swapin & Swapout)](http://jake.dothome.co.kr/swap-2/) - 1, 3, 4번 글도 읽어보면 도움이 될 듯.

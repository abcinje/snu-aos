# What Should We Do

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

### leap_functionality_init()

- insmod 명령을 통해 동적으로 linux default readahead와, leap prefetch를 전환할 수 있음
- 해당 명령에 따라 get_custom_prefetch() 의 결과가 달라지며, get_custom_prefetch() != 0 일때 leap 관련 동작이 수행됨

### find_trend()

- swapin_readahead() 에서 find_trend() 호출
- 하위 함수 포함 총 40여줄로 코드는 길지 않고, window size를 2배씩 늘려가며 trend를 찾는 내용
- 결과에 따라 trend가 확인되면 read_swap_cache_async() 를 호출함
- 프로젝트를 위해 가져와야 할 핵심 함수

### log_swap_trend()

- lookup_swap_cache() 에서 (get_custom_prefetch() 가 0이 아닐때) low_swap_trend() 를 호출해서 trend를 기록함
- 총 20여줄로 trend(entry와 delta) 기록하는 간단한 동작

### 분석 방향

- find_trend() 와 log_swap_trend() 두 함수를 어느 위치에 적용할지에 대해 논의가 필요할듯

---

### References
[1] [문c 블로그, Swap -2- (Swapin & Swapout)](http://jake.dothome.co.kr/swap-2/) - 1, 3, 4번 글도 읽어보면 도움이 될 듯.  
[2] [Linux readahead: less tricks for more](https://www.kernel.org/doc/ols/2007/ols2007v2-pages-273-284.pdf) - 기존 리눅스 프리패칭

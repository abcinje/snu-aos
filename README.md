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

### 적용 위치 고민

1. page --> CPU cache로의 prefetch에 적용
  - Leap의 trend 기법을 적용하기에 마땅한 위치가 없음
  - 주소와 범위를 지정하여 prefetch하는 prefetch_range() 함수가 존재하나 현재 사용하는 5.4.59 기준으로 caller가 없고, 이전 history를 봐도 일부 driver 등에서 제한적으로만 사용됨
  - 그 외의 prefetch() 호출은 각 codeflow에서 다음에 사용할 변수나 객체를 지정하여 prefetch하는 것들로, 현재 목적과는 어울리지 않는 내용임

2. swap --> page로의 prefetch
  - 기존 Leap 저자들이 수정한 kernel과 유사한 형태로 구현 가능

3. file --> page로의 prefetch
  - __do_fault() --> filemap_fault() --> ... --> ondemand_readahead() 로 이어지는 흐름에도 적용이 가능할 것으로 보임
  - ondemand_readahead() 에 sequential read 인지 판단하여 readahead 여부를 결정하는 로직이 있으며 이부분에 Leap 아이디어를 적용해볼 수 있을 것으로 보임
  - 적용했을 때 이득을 볼수 있을 것인지? 어떻게 적용할 것인지? 확인이 필요

---

### References
[1] [문c 블로그, Swap -2- (Swapin & Swapout)](http://jake.dothome.co.kr/swap-2/) - 1, 3, 4번 글도 읽어보면 도움이 될 듯.  
[2] [Linux readahead: less tricks for more](https://www.kernel.org/doc/ols/2007/ols2007v2-pages-273-284.pdf) - 기존 리눅스 프리패칭

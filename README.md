# systemverilog_miniproject

SystemVerilog를 이용한 UART 제어 10000 카운터 설계 및 검증

FPGA-based 10000 Counter with UART Interface: Design and Verification in SystemVerilog

📝 프로젝트 개요 (Overview)
본 프로젝트는 

하만교육 2기 과정의 일환으로 진행되었으며, FPGA의 물리적 버튼과 UART 통신 명령어를 통해 10000 카운터를 제어하는 시스템을 설계하고 검증하는 것을 목표로 합니다.



주요 목표는 Verilog HDL을 사용하여 UART(FIFO 포함) 및 카운터 로직을 설계하고 , 

SystemVerilog를 기반으로 한 체계적인 테스트벤치 환경을 구축하여 설계의 기능적 정확성을 검증하고 최종 리포트를 생성하는 것입니다.

팀원:

황주빈

김태형 

✨ 주요 기능 (Key Features)

카운터 제어: FPGA의 버튼 입력과 UART CMD를 통해 카운터의 동작(enable, mode, clear)을 제어합니다.



UART 통신: 비동기 직렬 통신(UART)을 위한 RX(수신), TX(송신) 모듈 및 데이터 버퍼링을 위한 FIFO를 구현했습니다.


SystemVerilog 검증 환경: 기능 검증을 자동화하고 결과를 체계적으로 분석하기 위해 SystemVerilog 기반의 테스트벤치를 구축했습니다.


결과 리포팅: 모든 테스트 시나리오의 통과 여부를 요약한 최종 테스트 리포트를 생성합니다.

🔧 시스템 아키텍처 (System Architecture)

<img width="1430" height="510" alt="image" src="https://github.com/user-attachments/assets/c9416c48-9919-432a-9413-701cbc53e000" />

UART_TOP: PC로부터 UART 명령어를 수신(RX)하고 처리 결과를 송신(TX)하는 최상위 모듈입니다.


CMD_CU (Command Control Unit): UART_TOP에서 수신된 데이터를 해석하여 카운터를 제어하는 신호(enable, mode, clear)를 생성합니다.


BD_D,L,R: FPGA 보드의 물리적 버튼 입력을 처리하는 부분입니다.


COUNTER: 실제 0부터 9999까지 카운팅을 수행하는 핵심 모듈입니다.


FND_CNTL: 카운터 값을 FND(7-Segment)에 표시하기 위한 제어 로직입니다.


1KHZ_CLK: 버튼 디바운싱을 위해 생성한 1kHz clock

🧪 검증 환경 및 절차 (Verification Environment & Process)
설계된 UART 모듈의 신뢰성을 보장하기 위해 SystemVerilog로 검증 환경을 구축했습니다. 테스트벤치는 

RX -> RX_FIFO -> TX_FIFO -> TX 순으로 데이터 흐름을 검증하도록 구성되었습니다.

<img width="1389" height="443" alt="image" src="https://github.com/user-attachments/assets/7e0bc235-28db-469e-a681-f31f6d061897" />


1. UART RX 검증

시나리오: Generator가 생성한 임의의 데이터(예: 0x44)를 Driver가 send_data 태스크를 통해 DUT의 RX 핀으로 전송합니다.


검증: RX 모듈이 수신하여 내부 데이터로 변환한 값이 Driver가 보낸 원본 데이터와 일치하는지 확인합니다.

결과: [PASS] UART RX data matched! (Value: 44) 로그를 통해 수신 데이터의 정합성을 확인했습니다.

2. FIFO сквозная 검증 (End-to-End Verification)
시나리오: RX 모듈을 통해 RX_FIFO에 저장된 데이터가 TX_FIFO로 정상적으로 전달되는지 확인합니다.


검증: RX_FIFO의 입력 데이터와 TX_FIFO의 출력 데이터를 비교합니다.


결과: [Rx FIFO - Tx FIFO SUCCESS] 메시지를 통해 데이터가 FIFO를 거치며 손실이나 변형 없이 전달되었음을 확인했습니다.

3. UART TX 검증

시나리오: Monitor가 DUT의 TX 핀에서 출력되는 직렬 데이터를 비트 단위로 샘플링하여 8비트 데이터로 재구성합니다.


검증: 재구성된 데이터가 TX_FIFO에서 나온 원본 데이터와 일치하는지 확인합니다.

결과: [PASS] UART TX data matched! (Value: 0x44) 로그를 통해 송신 데이터의 정합성을 확인했습니다.

4. 최종 결과 리포트 (Final Report)

Scoreboard: 전송된 데이터와 최종 수신된 데이터를 비교하여 전체 트랜잭션의 성공 여부를 최종적으로 확인합니다.


Test Summary Report: 총 10개의 트랜잭션을 실행하여 100%의 통과율을 달성했으며, OVERALL STATUS : ALL PASSED로 모든 검증이 성공적으로 완료되었음을 확인했습니다.

🚀 시작하기 (Getting Started)
이 프로젝트를 로컬 환경에서 실행하려면 아래의 도구가 필요합니다.

시뮬레이션: Synopsys VCS, Cadence Xcelium, or Siemens Questa Sim

합성 및 구현: Xilinx Vivado or Intel Quartus

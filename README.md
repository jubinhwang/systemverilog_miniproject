# UART 제어 10000진 카운터: 설계 및 검증 (SystemVerilog)
FPGA-based 10000 Counter with UART Interface: Design and Verification in SystemVerilog

## 📝 프로젝트 개요 (Overview)

본 프로젝트는 **하만교육 2기** 과정의 미니 프로젝트입니다.

프로젝트의 목표는 FPGA의 물리적 버튼과 UART 통신 명령어, 두 가지 방식을 통해 **10000진 카운터**를 제어하는 시스템을 설계하고 검증하는 것입니다.

주요 과제는 Verilog HDL로 10000진 카운터 및 FND 제어 로직을, SystemVerilog로 UART(FIFO 포함) 모듈을 설계하는 것입니다. 이후 SystemVerilog 기반의 테스트벤치(Testbench)를 구축하여 설계의 기능적 정확성을 검증하고, 최종 리포트를 생성하는 과정을 다룹니다.

* **사용 보드**: Digilent Basys3
  <img width="512" height="321" alt="image" src="https://github.com/user-attachments/assets/e8fe7550-9f02-4e48-a92d-0786d13b76a2" />


## ✨ 주요 기능 (Key Features)

* **듀얼 컨트롤**: FPGA 보드에 탑재된 물리적 버튼과 PC의 UART 터미널 명령어를 모두 사용하여 카운터의 동작(`enable`, `mode`, `clear`)을 제어합니다.
* **UART 통신 모듈**: 데이터 송수신(RX/TX) 및 버퍼링을 위한 `RX_FIFO`, `TX_FIFO`를 포함한 비동기 직렬 통신(UART) 모듈을 구현했습니다.
* **SystemVerilog 검증 환경**: `Generator`, `Driver`, `Monitor`, `Scoreboard` 및 `mailbox`를 활용한 테스트벤치를 구축하여 기능 검증을 자동화하고 결과를 체계적으로 분석합니다.
* **결과 리포팅**: 모든 테스트 시나리오의 통과 여부를 요약한 최종 테스트 리포트를 생성합니다.

## 🔧 시스템 아키텍처 (System Architecture)

<img width="2029" height="627" alt="image" src="https://github.com/user-attachments/assets/5a62f493-c0fa-4ef4-888a-021042b52f25" />


* **`UART_TOP`**: PC로부터 UART 명령어를 수신(RX)하고 처리 결과를 송신(TX)하는 최상위 모듈입니다.
* **`CMD_CU` (Command Control Unit)**: `UART_TOP`에서 수신된 데이터를 해석하여 카운터를 제어하는 신호(`o_cmd_clear`, `o_cmd_mode`, `o_cmd_run`)를 생성합니다.
* **`BD_D,L,R`**: FPGA 보드의 물리적 버튼 입력(`btn_D`, `btn_L`, `btn_R`)에 대한 디바운싱(Debouncing)을 처리하는 모듈입니다.
* **`COUNTER`**: `CMD_CU` 또는 버튼 입력으로부터 제어 신호를 받아 0부터 9999까지 카운팅을 수행하는 10000진 카운터 모듈입니다.
* **`FND_CNTL`**: 카운터 값을 4자리의 FND(7-Segment)에 표시하기 위한 제어 로직입니다.
* **`1KHZ_CLK`**: 버튼 디바운싱 로직에 사용하기 위한 1kHz 클럭 생성 모듈입니다.

## 🧪 검증 환경 및 절차 (Verification Environment & Process)

설계된 UART 모듈의 신뢰성을 보장하기 위해 SystemVerilog로 검증 환경을 구축했습니다.
<img width="841" height="733" alt="image" src="https://github.com/user-attachments/assets/1e90ab59-37cf-4c00-a211-7ad38bf4e21d" />

#### 테스트벤치 구성 요소 (Testbench Components)
<img width="1398" height="418" alt="image" src="https://github.com/user-attachments/assets/095ef2b6-c31a-4353-b179-3e3b15e061d8" />

* **`GEN (Generator)`**: 검증을 위한 랜덤 트랜잭션(데이터)을 생성합니다.
* **`DRV (Driver)`**: `gen2drv` 메일박스를 통해 `GEN`으로부터 트랜잭션을 받아, DUT의 `RX` 핀으로 직렬 데이터를 인가합니다. 동시에, 원본 데이터를 `DRV2MON` 메일박스를 통해 `MON`으로 전달합니다.
* **`MON (Monitor)`**: DUT의 `TX` 핀에서 출력되는 직렬 데이터를 비트 단위로 샘플링하여 데이터를 재구성하고, `DRV2MON` 메일박스에서 원본 데이터를 받아 `mon2scb` 메일박스로 전달합니다.
* **`SCB (Scoreboard)`**: `mon2scb` 메일박스에서 데이터를 받아, `Driver`가 전송한 원본 데이터와 `Monitor`가 수신한 최종 데이터가 일치하는지 비교하여 트랜잭션의 통과/실패를 판정합니다.

#### 검증 절차 (Verification Process)

테스트벤치는 **`RX` -> `RX_FIFO` -> `TX_FIFO` -> `TX`** 순으로 데이터 흐름을 체계적으로 검증합니다.

1.  **UART RX 검증**
    * **시나리오**: Generator가 생성한 임의의 데이터(예: `0x44`)를 Driver가 DUT의 `RX` 핀으로 전송합니다.
    * **검증**: `RX` 모듈이 수신하여 `internal_rx_data` 레지스터에 저장한 값이 원본 데이터와 일치하는지 확인합니다.
    * **결과**: `[PASS RX SUCCESS] UART RX data MATCHED!` 로그를 통해 데이터 정합성을 확인했습니다.

2.  **FIFO 검증**
    * **시나리오**: `RX_FIFO`에 저장된 데이터가 `TX_FIFO`로 정상적으로 전달되는지 확인합니다.
    * **검증**: `RX_FIFO`의 입력 데이터(`internal_rx_data`)와 `TX_FIFO`의 출력 데이터(`o_rx_data`)를 비교합니다.
    * **결과**: `[Rx FIFO - Tx FIFO SUCCESS]` 메시지를 통해 FIFO 간의 데이터 전송 신뢰성을 확인했습니다.

3.  **UART TX 검증**
    * **시나리오**: Monitor가 DUT의 `TX` 핀에서 출력되는 직렬 데이터를 샘플링하여 8비트 데이터로 재구성합니다.
    * **검증**: 재구성된 데이터(`trans.uart_re_data`)가 `TX_FIFO`에서 읽어온 원본 데이터(`uart_fifo_if.o_rx_data`)와 일치하는지 확인합니다.
    * **결과**: `[PASS] UART TX data matched!` 로그를 통해 송신 데이터의 정합성을 확인했습니다.

4.  **최종 결과 리포트 (Final Report)**
    * **Scoreboard**: `Driver`가 전송한 원본 데이터(`SENT DATA`)와 `Monitor`가 `TX` 핀에서 최종 수신한 데이터(`RECEIVED DATA`)를 비교하여 전체 트랜잭션의 성공 여부를 최종 판정합니다.
    * **Test Summary Report**: 총 **256개**의 랜덤 트랜잭션을 실행하여 **100.00 % 통과율**을 달성했으며, `OVERALL STATUS : ALL PASSED`로 모든 검증이 성공적으로 완료되었음을 확인했습니다.

## 📈 최종 시뮬레이션 결과 (Final Simulation)

`Counter_10000` 모듈의 시뮬레이션 파형입니다. 버튼 입력 (`btn_D`, `btn_R`, `btn_L`) 및 UART 입력 (`rx` 신호)에 따라 카운터(`w_counter`)가 `Start`, `Mode`, `Reset` 등 설계된 대로 정상 동작하는 것을 확인했습니다.
<img width="1385" height="783" alt="image" src="https://github.com/user-attachments/assets/a00326f2-dc4e-4b93-b3e7-b545a99f9975" />



## 🐛 트러블슈팅 (Troubleshooting)

검증 환경 구축 및 테스트 과정에서 발생했던 주요 이슈와 해결 과정을 공유합니다.

### 1. Mailbox를 통한 데이터 정합성 문제
* **문제**: `Monitor`가 DUT의 `TX`에서 수신한 데이터를 `Scoreboard`로 보내기 전, 비교 대상인 "원본 데이터"를 알아야 했습니다. 초기 `Monitor`는 `trans = new();`로 새 트랜잭션을 생성하여, `Driver`가 보낸 원본 값(예: `0x44`)이 아닌 초기값(예: `0x00`)을 "원본 데이터"로 잘못 참조하는 문제가 발생했습니다.
* **해결**: `Driver`와 `Monitor` 간에 `drv2mon_mbox`라는 별도의 메일박스를 추가했습니다. `Driver`는 DUT에 데이터를 전송하는 동시에, 이 메일박스를 통해 "원본 데이터 트랜잭션"을 `Monitor`에 직접 전달합니다. `Monitor`는 `TX` 샘플링 후 이 메일박스에서 원본 데이터를 `get()`하여, `Scoreboard`로 (원본 데이터, 수신 데이터) 쌍을 올바르게 전달할 수 있었습니다.

### 2. TX 데이터 캐치(Catch) 타이밍
* **문제**: `Driver`가 `RX`로 데이터를 전송한 직후, DUT가 이 데이터를 처리(latch)하기 전에 `Driver`가 다음 동작으로 넘어가면서 데이터 비교 시점에 `xx` (unknown) 값이 발생하는 타이밍 이슈가 있었습니다.
* **해결**: `Driver`의 `send_data` 태스크 내부에, 데이터 비트 전송이 모두 끝난 후 DUT의 `cmd_start` 신호가 `negedge`가 될 때까지 대기하는 로직(`@ (negedge uart_fifo_if.cmd_start);`)을 추가했습니다. 이 `cmd_start` 신호는 DUT가 `RX` 수신을 완료하고 데이터를 래치했음을 의미하므로, 이 시점까지 대기함으로써 안정적인 데이터 동기화를 보장했습니다.

### 3. RX 데이터 비교 타이밍 이슈
* **문제**: 초기에는 `Driver`가 `RX` 데이터 전송 직후, 해당 데이터를 DUT가 올바르게 수신했는지 즉시 비교했습니다. 이는 `Driver`의 역할(데이터 인가)과 `Monitor`의 역할(데이터 확인)이 혼재된 구조였으며, DUT의 처리 지연을 고려하지 못해 간헐적인 오류가 발생했습니다.
* **해결**: `RX` 데이터 수신 확인의 책임을 `Driver`에서 `Monitor`로 이전했습니다. `Monitor`는 `Driver`로부터 `mon_next_event` 이벤트를 받아 `RX` 수신이 완료되었음을 인지한 후, `drv2mon_mbox`에서 원본 데이터를 가져와 DUT 내부의 수신 레지스터(`internal_rx_data`) 값과 비교하도록 수정했습니다. 이로써 검증 로직이 DUT의 실제 동작 시점 이후에 수행되도록 보장했습니다.

## 🚀 시작하기 (Getting Started)

이 프로젝트를 실제 **Basys3** 보드에서 구현하고 테스트하기 위한 단계별 가이드입니다.

#### ✅ 사전 요구사항 (Prerequisites)
프로젝트를 진행하기 전, 아래의 개발 환경과 도구가 준비되어 있는지 확인해주세요.

* 💻 **FPGA 개발 환경**: **Vivado 2020.2** 버전
* 🤖 **FPGA 보드**: **Digilent Basys3 보드**
    > ⚠️ 본 프로젝트의 제약 조건 파일(`constrs_1`)은 Basys3 보드에 맞춰 작성되었습니다.
* 📡 **UART 통신 프로그램**: **ComPortMaster**, PuTTY, Tera Term 등

#### 🛠️ 설치 및 실행 절차 (Step-by-Step Guide)

1.  **📂 프로젝트 파일 다운로드**

    먼저, 이 GitHub 저장소의 모든 파일을 로컬 PC로 복제(clone)합니다.
    ```bash
    git clone [https://github.com/jubinhwang/systemverilog_miniproject.git](https://github.com/jubinhwang/systemverilog_miniproject.git)
    cd systemverilog_miniproject/UART_10000COUNTER
    ```

2.  **⚙️ Vivado 프로젝트 생성 및 설정**

    **Vivado 2020.2**를 실행하여 아래 단계에 따라 프로젝트를 설정합니다.
    * **프로젝트 생성**: 새 프로젝트를 시작하고, 타겟 보드로 **Basys3**를 선택합니다.
    * **소스 파일 추가 (Add Sources)**:
        * **Design Sources**: `sources_1` 폴더 내의 모든 Verilog (`.v`) 파일을 추가합니다.
        * **Constraints**: `constrs_1` 폴더의 XDC (`.xdc`) 파일을 추가합니다.
        * **Simulation Sources**: `sim_1` 폴더 내의 모든 파일을 추가합니다.

3.  **🔌 Bitstream 생성 및 FPGA 프로그래밍**

    프로젝트 설정이 완료되면, FPGA에 업로드할 비트스트림 파일을 생성합니다.
    * **Bitstream 생성**: Vivado 좌측의 **Flow Navigator**에서 **`Generate Bitstream`**을 클릭합니다.
    * **FPGA 프로그래밍**:
        1.  **Hardware Manager**를 엽니다.
        2.  PC에 **Basys3** 보드를 연결하고 전원을 켭니다.
        3.  `Open target` -> `Auto Connect`를 통해 보드를 인식시킵니다.
        4.  **`Program device`**를 클릭하여 방금 생성된 `.bit` 파일을 보드에 업로드합니다.

4.  **🖥️ UART 통신 및 기능 테스트**

    마지막으로, **ComPortMaster**를 이용해 UART 통신으로 카운터를 제어합니다.
    * **ComPortMaster 실행**: 프로그램을 열고 Basys3 보드가 연결된 **COM 포트**를 선택합니다.
    * **통신 설정**: 프로젝트 사양에 맞는 **Baud rate** 등의 통신 설정을 완료합니다.
    * **기능 확인**: 터미널을 통해 **제어 명령어**를 전송하며 카운터가 설계된 대로 올바르게 동작하는지 실시간으로 확인합니다.

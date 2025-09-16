#  UART 제어 10000 카운터: 설계 및 검증 (SystemVerilog)
**FPGA-based 10000 Counter with UART Interface: Design and Verification in SystemVerilog**

---

### 📝 프로젝트 개요 (Overview)
본 프로젝트는 **하만교육 2기** 과정으로 진행되었습니다. FPGA의 물리적 버튼과 UART 통신 명령어를 통해 **10000진 카운터**를 제어하는 시스템을 설계하고 검증하는 것을 목표로 합니다.

주요 과제는 Verilog HDL로 10000진 카운터를, SystemVerilog로 UART 및 FIFO 로직을 설계하는 것입니다. 이후 SystemVerilog 기반의 테스트벤치를 구축하여 설계의 기능적 정확성을 검증하고 최종 리포트를 생성합니다

* **팀원**: 황주빈, 김태형

---

### ✨ 주요 기능 (Key Features)
* **듀얼 컨트롤**: FPGA 버튼과 UART 명령어를 모두 사용하여 카운터의 동작(`enable`, `mode`, `clear`)을 제어합니다.
* **UART 통신 모듈**: 데이터 버퍼링을 위한 FIFO를 포함한 비동기 직렬 통신(UART) `RX` 및 `TX` 모듈을 구현했습니다.
* **SystemVerilog 검증 환경**: 기능 검증을 자동화하고 결과를 체계적으로 분석하기 위한 테스트벤치를 구축했습니다.
* **결과 리포팅**: 모든 테스트 시나리오의 통과 여부를 요약한 최종 테스트 리포트를 생성합니다.

---

### 🔧 시스템 아키텍처 (System Architecture)
<img width="1430" alt="System Architecture Block Diagram" src="https://github.com/user-attachments/assets/c9416c48-9919-432a-9413-701cbc53e000" />

* **`UART_TOP`**: PC로부터 UART 명령어를 수신(RX)하고 처리 결과를 송신(TX)하는 최상위 모듈입니다.
* **`CMD_CU` (Command Control Unit)**: 수신된 데이터를 해석하여 카운터를 제어하는 신호를 생성합니다.
* **`BD_D,L,R`**: FPGA 보드의 물리적 버튼 입력을 처리하는 버튼 디바운싱을 위한 모듈입니다.
* **`COUNTER`**: 0부터 9999까지 카운팅을 수행하는 모듈입니다.
* **`FND_CNTL`**: 카운터 값을 FND(7-Segment)에 표시하기 위한 제어 로직입니다.
* **`1KHZ_CLK`**: 버튼 디바운싱(Debouncing)을 위해 생성한 1kHz 클럭입니다.

---

### 🧪 검증 환경 및 절차 (Verification Environment & Process)
설계된 UART 모듈의 신뢰성을 보장하기 위해 SystemVerilog로 검증 환경을 구축했습니다. 테스트벤치는 **`RX` -> `RX_FIFO` -> `TX_FIFO` -> `TX`** 순으로 데이터 흐름을 체계적으로 검증합니다.

<img width="1389" alt="Testbench Block Diagram" src="https://github.com/user-attachments/assets/7e0bc235-28db-469e-a681-f31f6d061897" />

#### 1. UART RX 검증
* **시나리오**: Generator가 생성한 임의의 데이터(예: `0x44`)를 Driver가 DUT의 `RX` 핀으로 전송합니다.
* **검증**: `RX` 모듈이 수신한 데이터가 원본 데이터와 일치하는지 확인합니다.
* **결과**: `[PASS] UART RX data matched!` 로그를 통해 데이터 정합성을 확인했습니다.

#### 2. FIFO 검증 
* **시나리오**: `RX_FIFO`에 저장된 데이터가 `TX_FIFO`로 정상적으로 전달되는지 확인합니다.
* **검증**: `RX_FIFO`의 입력 데이터와 `TX_FIFO`의 출력 데이터를 비교합니다.
* **결과**: `[Rx FIFO - Tx FIFO SUCCESS]` 메시지를 통해 FIFO 동작의 신뢰성을 확인했습니다.

#### 3. UART TX 검증
* **시나리오**: Monitor가 DUT의 `TX` 핀에서 출력되는 직렬 데이터를 비트 단위로 샘플링하여 재구성합니다.
* **검증**: 재구성된 데이터가 `TX_FIFO`의 원본 데이터와 일치하는지 확인합니다.
* **결과**: `[PASS] UART TX data matched!` 로그를 통해 송신 데이터의 정합성을 확인했습니다.

#### 4. 최종 결과 리포트 (Final Report)
* **Scoreboard**: 전송된 데이터와 최종 수신된 데이터를 비교하여 전체 트랜잭션의 성공 여부를 최종 판정합니다.
* **Test Summary Report**: 총 10개의 트랜잭션을 실행하여 **100% 통과율**을 달성했으며, `OVERALL STATUS : ALL PASSED`로 모든 검증이 성공적으로 완료되었음을 확인했습니다.

---

### 🚀 시작하기 (Getting Started)

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

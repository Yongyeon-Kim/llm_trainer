# LLM Trainer

이 프로젝트는 [LLaMA Factory](https://github.com/hiyouga/LlamaFactory) 코드를 기반으로 하며, 대규모 언어 모델(LLM)의 사전 학습(Pre-training) 및 미세 조정(Fine-tuning)을 수행합니다. 모든 작업은 Docker 컨테이너 환경에서 실행됩니다.

## 사전 준비

- Docker 및 Docker Compose
- NVIDIA GPU 및 [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

## 디렉토리 구조

- **`models/base/`**: 학습에 사용할 기본 모델을 이 디렉토리에 위치시킵니다.
- **`models/output/`**: 학습이 완료된 모델이 저장되는 경로입니다. `pt`와 `sft` 하위 폴더로 구분됩니다.
- **`data/`**: 학습에 사용될 데이터셋이 저장됩니다. 모든 데이터셋 정보는 `data/dataset_info.json`에 정의되어 있습니다.
- **`run_train/`**: PT(Pre-training) 및 SFT(Supervised Fine-tuning)를 위한 셸 스크립트가 포함되어 있습니다.
- **`logs/`**: 학습 과정의 로그 파일이 저장됩니다.

## 학습 진행 방법

1.  **Docker 컨테이너 시작**

    프로젝트 루트 디렉토리에서 아래 명령어를 실행하여 Docker 컨테이너를 시작합니다.
    ```bash
    docker compose up -d
    ```

2.  **컨테이너 접속**

    실행 중인 컨테이너 내부로 접속합니다.
    ```bash
    docker compose exec llm_trainer bash
    ```

3.  **학습 스크립트 수정 및 실행**

    `run_train/` 디렉토리 내의 `run_pt.sh` 또는 `run_sft.sh` 스크립트 파일을 필요에 맞게 수정합니다. 주요 수정 변수는 다음과 같습니다.

    - `MODEL_NAME`: `models/base/` 내에 있는 기본 모델의 디렉토리명
    - `DATASET`: `data/dataset_info.json`에 정의된 데이터셋 키
    - `SAVE_MODEL_NAME`: 저장될 모델의 이름

    SFT 학습을 예로 들면, 스크립트를 수정한 후 아래와 같이 실행합니다. 기본적으로 백그라운드에서 실행되도록 설정되어 있습니다.
    ```bash
    # 컨테이너 내부에서 실행
    nohup bash run_train/run_sft.sh &
    ```

4.  **학습 과정 모니터링 (백그라운드 실행 시)**

    스크립트 실행 시 로그 파일 경로가 출력됩니다. `tail -f` 명령어를 사용하여 실시간으로 학습 과정을 확인할 수 있습니다.
    ```bash
    # 예시: logs 디렉토리의 해당 로그 파일 확인
    tail -f logs/gemma-2-9b_sft_1e-5_instruct_v3.log
    ```
    *Tip: `Ctrl + C`를 눌러 로그 확인을 중단해도 학습은 백그라운드에서 계속 진행됩니다.*

5.  **학습 상태 확인 (추가)**

    학습이 정상적으로 진행 중인지 확인하려면 아래 명령어들을 사용할 수 있습니다.
    - **GPU 사용량 확인:** `nvidia-smi` 명령어로 GPU 부하와 메모리 점유율을 확인합니다.
    - **프로세스 확인:** `ps aux | grep train.py` 명령어로 학습 프로세스가 살아있는지 확인합니다.

6.  **결과 확인**

    - 학습 로그는 `logs/` 디렉토리 내에 스크립트에서 지정한 파일명(`*.log` 또는 `*.out`)으로 생성됩니다.
    - 학습된 모델 가중치는 `models/output/` 디렉토리 내에 저장됩니다.

## 컨테이너 종료

학습이 완료되면 아래 명령어로 컨테이너를 종료할 수 있습니다.
```bash
docker compose down
```

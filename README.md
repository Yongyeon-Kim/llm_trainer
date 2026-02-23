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

    SFT 학습을 예로 들면, 스크립트를 수정한 후 아래와 같이 실행합니다.
    ```bash
    bash run_train/run_sft.sh
    ```

4.  **결과 확인**

    - 학습 로그는 `logs/` 디렉토리 내에 스크립트에서 지정한 파일명(`*.log` 또는 `*.out`)으로 생성됩니다.
    - 학습된 모델 가중치는 `models/output/` 디렉토리 내에 저장됩니다.

## 컨테이너 종료

학습이 완료되면 아래 명령어로 컨테이너를 종료할 수 있습니다.
```bash
docker compose down
```

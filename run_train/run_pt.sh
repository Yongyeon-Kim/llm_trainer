##### 학습 config 설정
##### llama -> bf16, gpt-> fp16
export CUDA_LAUNCH_BLOCKING=1
export HF_DATASETS_CACHE=/workspace/huggingface/cache/

MODEL_PATH="/model/base" ### base 모델 경로
MODEL_NAME=""                                      ### 학습하고자 하는 base 모델명
DATASET=""                                    ### dataset_info.json에 들어갈 데이터 key값
LOG_PATH="logs"                                                ### 학습 log 저장 경로
SAVE_MODEL_PATH="/model/output/pt"     ### 학습모델 저장 경로 
SAVE_MODEL_NAME=""                    ### 학습모델명

nohup deepspeed --num_gpus 8 --master_port=9901 src/train.py > ${LOG_PATH}/${SAVE_MODEL_NAME}.out \
    --deepspeed configs/ds3_bf_stage_v2.json \
    --stage pt \
    --do_train \
    --model_name_or_path ${MODEL_PATH}/${MODEL_NAME} \
    --dataset ${DATASET} \
    --finetuning_type full \
    --cutoff_len 2048 \
    --preprocessing_num_workers=8 \
    --ddp_timeout=360000 \
    --output_dir ${SAVE_MODEL_PATH}/${SAVE_MODEL_NAME} \
    --per_device_train_batch_size 4 \
    --gradient_accumulation_steps 8 \
    --lr_scheduler_type cosine \
    --logging_steps 5 \
    --save_strategy steps \
    --save_steps 100 \
    --save_total_limit 5 \
    --adam_epsilon 1e-8 \
    --learning_rate 1e-5 \
    --num_train_epochs 1.0 \
    --plot_loss \
    --bf16 &
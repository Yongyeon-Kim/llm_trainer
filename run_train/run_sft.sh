export NCCL_DEBUG=WARN
export CUDA_VISIBLE_DEVICES=0
export CUDA_LAUNCH_BLOCKING=1
export HF_DATASETS_CACHE=/workspace/huggingface/cache/

#MODEL_PATH="models/base"
MODEL_PATH="models/base"
MODEL_NAME="gemma-2-9b"                                      
DATASET="instruction_sft_v4"                                    
LOG_PATH="logs"                                                
SAVE_MODEL_PATH="models/output/sft"     
SAVE_MODEL_NAME="gemma-2-9b_sft_1e-5_instruct_v3"                 

nohup deepspeed --num_gpus 1 --master_port=9901 src/train.py > ${LOG_PATH}/${SAVE_MODEL_NAME}.log \
    --stage sft \
    --do_train \
    --model_name_or_path ${MODEL_PATH}/${MODEL_NAME} \
    --dataset ${DATASET} \
    --deepspeed configs/ds_bf_zero3.json \
    --template gemma \
    --finetuning_type full \
    --output_dir ${SAVE_MODEL_PATH}/${SAVE_MODEL_NAME} \
    --overwrite_cache False \
    --per_device_train_batch_size 4 \
    --gradient_accumulation_steps 6 \
    --lr_scheduler_type cosine \
    --logging_steps 10 \
    --save_strategy epoch \
    --save_total_limit 2 \
    --learning_rate 1e-5 \
    --num_train_epochs 3.0 \
    --plot_loss \
    --bf16 &

echo "Main inference script started with logs at : ${LOG_PATH}/${SAVE_MODEL_NAME}.log"
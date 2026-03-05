# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.1-base

# install custom nodes into comfyui (first node with --mode remote to fetch updated cache)
# The workflow contains only unknown_registry custom nodes without aux_id (no GitHub repo specified), so they cannot be installed automatically.
# Could not resolve unknown_registry node: ModelSamplingSD3 - no aux_id provided; skipped
# Could not resolve unknown_registry node: ModelSamplingSD3 - no aux_id provided; skipped
# Could not resolve unknown_registry node: SaveVideo - no aux_id provided; skipped
# Could not resolve unknown_registry node: CreateVideo - no aux_id provided; skipped
# Could not resolve unknown_registry node: EmptyHunyuanLatentVideo - no aux_id provided; skipped

# download models into comfyui
RUN comfy model download --url https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors --relative-path models/text_encoders --filename umt5_xxl_fp8_e4m3fn_scaled.safetensors
RUN comfy model download --url https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors --relative-path models/vae --filename wan_2.1_vae.safetensors
RUN comfy model download --url https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_t2v_high_noise_14B_fp16.safetensors --relative-path models/diffusion_models/Wan2.2 --filename wan2.2_t2v_high_noise_14B_fp16.safetensors
RUN comfy model download --url https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_t2v_low_noise_14B_fp16.safetensors --relative-path models/diffusion_models/Wan2.2 --filename wan2.2_t2v_low_noise_14B_fp16.safetensors

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/

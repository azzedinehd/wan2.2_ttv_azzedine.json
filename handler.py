import runpod
import urllib.request
import urllib.error
import json
import time
import os

COMFY_HOST = "127.0.0.1:8188"

def wait_for_comfy():
    while True:
        try:
            urllib.request.urlopen(f"http://{COMFY_HOST}/system_stats")
            return
        except:
            time.sleep(1)

def queue_prompt(prompt):
    data = json.dumps({"prompt": prompt}).encode()
    req = urllib.request.Request(f"http://{COMFY_HOST}/prompt", data=data)
    return json.loads(urllib.request.urlopen(req).read())

def get_history(prompt_id):
    with urllib.request.urlopen(f"http://{COMFY_HOST}/history/{prompt_id}") as r:
        return json.loads(r.read())

def handler(job):
    job_input = job["input"]
    prompt = job_input.get("prompt")
    
    wait_for_comfy()
    result = queue_prompt(prompt)
    prompt_id = result["prompt_id"]
    
    while True:
        history = get_history(prompt_id)
        if prompt_id in history:
            break
        time.sleep(1)
    
    outputs = history[prompt_id]["outputs"]
    videos = []
    for node_id, node_output in outputs.items():
        if "videos" in node_output:
            for video in node_output["videos"]:
                videos.append(video["filename"])
    
    return {"videos": videos}

runpod.serverless.start({"handler": handler})

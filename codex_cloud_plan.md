# claude驱使codex在云端执行任务的方案（简陋版）
这个方案的大概流程就是：让本地vs code中的Claude插件驱使codex在云中执行任务。
具体实现是：
- 给claude code编写一个slash command。
- 在slash command中指示claude code调用本地codex cloud exec命令，这样就能够将任务发送到codex的云端处理了。
- claude code插件在提交任务完成后会自动轮询云端任务是否完成。
- 如果任务完成，在slash command命令中指示claude code调用codex cloud apply命令，将云端改动拉取到本地。
- 这样就完成了一次任务驱动

slash command写法如下：  
```markdown
---
allowed-tools: Bash(codex cloud exec:*)
description: use codex cloud to handle tasks.
---

## Context
!`codex cloud exec --env 695e1c86ca908191a8129d602be7b81d 将首页去掉只剩下渐变背景`

## task

Use !`codex cloud apply`, then review the code
```

这个slash command里是写死的任务，后面在想法改成动态任务

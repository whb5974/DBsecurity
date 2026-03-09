#!/bin/bash
# ======================
# 手动推送脚本 - 指定文件上传到 GitHub
# ======================

WORKSPACE="/home/ghost/.openclaw/workspace"
REPO="origin"
BRANCH="master"

echo "📦 OpenClaw Workspace 手动推送工具"
echo "=================================="
echo ""

# 显示当前状态
echo "📊 当前 Git 状态:"
cd "$WORKSPACE" && git status --short
echo ""

# 让用户选择要添加的文件
echo "请选择要推送的文件:"
echo "  1) 添加所有修改 (git add -A)"
echo "  2) 添加指定文件"
echo "  3) 仅推送已暂存的更改"
echo "  4) 取消"
echo ""
read -p "输入选项 (1-4): " choice

case $choice in
    1)
        git add -A
        echo "✅ 已添加所有修改"
        ;;
    2)
        read -p "输入文件路径 (空格分隔): " files
        git add $files
        echo "✅ 已添加指定文件"
        ;;
    3)
        echo "✅ 使用已暂存的更改"
        ;;
    4)
        echo "❌ 已取消"
        exit 0
        ;;
    *)
        echo "❌ 无效选项"
        exit 1
        ;;
esac

echo ""
git status --short
echo ""

# 输入提交信息
read -p "输入提交信息: " message
if [ -z "$message" ]; then
    echo "❌ 提交信息不能为空"
    exit 1
fi

# 提交
git commit -m "$message"
if [ $? -ne 0 ]; then
    echo "❌ 提交失败"
    exit 1
fi

echo ""
echo "📤 推送到 GitHub..."
git push $REPO $BRANCH

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 推送成功!"
    git log --oneline -3
else
    echo ""
    echo "❌ 推送失败，请检查网络连接"
    exit 1
fi

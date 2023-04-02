# 当发⽣错误时中⽌脚本

set -e

# 构建

npm run build

# cd 到构建输出的⽬录下 

cd dist
git init
git add -A

git commit -m 'deploy'

# 部署到 https://<USERNAME>.github.io/<REPO>

git push -f git@github.com:uuolonn/chat-bot.git master:gh-pages
cd -
# helptexts



== Check out a shallow clone of db files from PP-repo
mkdir pingpong
cd pingpong
git init
git remote add origin ssh://banan.pingpong.net/git/pingpong
git config core.sparseCheckout true
echo "src/java/net/pingpong/db" >> .git/info/sparse-checkout
git pull --depth=1 origin master


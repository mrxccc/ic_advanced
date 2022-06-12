# course05

# 示例：
![图片](img/1.jpg)
![图片](img/2.jpg)
![图片](img/3.jpg)
![图片](img/4.jpg)
# deploy命令
cd7qk-my6ce-anlh6-7wlh5-lw5ry-3ml6o-sjoqg-24cdj-fbryj-7sug2-cqe
vsyhq-akc5g-dv6r5-egp32-ylr2k-whhrg-acmem-6tn5d-hd5pk-bnnix-gae
bjzn2-6c7qz-bxshs-njhqu-gfkjv-prktq-bzols-4jgio-f2kii-hfczr-5qe
dfx deploy --with-cycles=5000000000000 --argument '(2, vec {principal "cd7qk-my6ce-anlh6-7wlh5-lw5ry-3ml6o-sjoqg-24cdj-fbryj-7sug2-cqe"; principal "vsyhq-akc5g-dv6r5-egp32-ylr2k-whhrg-acmem-6tn5d-hd5pk-bnnix-gae"; principal "bjzn2-6c7qz-bxshs-njhqu-gfkjv-prktq-bzols-4jgio-f2kii-hfczr-5qe"})'

cd7qk-my6ce-anlh6-7wlh5-lw5ry-3ml6o-sjoqg-24cdj-fbryj-7sug2-cqe
b3ybk-i3254-enljl-hi3ia-hm3d2-drsf4-y6xul-xdl4f-vxxu6-walfx-zqe
ajsnu-kfj3b-eougo-6inua-herig-bjc4h-ywhap-s4mlm-t4sn5-eq366-vae
dfx deploy --with-cycles=5000000000000 --argument '(2, vec {principal "cd7qk-my6ce-anlh6-7wlh5-lw5ry-3ml6o-sjoqg-24cdj-fbryj-7sug2-cqe"; principal "b3ybk-i3254-enljl-hi3ia-hm3d2-drsf4-y6xul-xdl4f-vxxu6-walfx-zqe"; principal "ajsnu-kfj3b-eougo-6inua-herig-bjc4h-ywhap-s4mlm-t4sn5-eq366-vae"})'
# 添加提案
dfx canister call course05 propose '(variant {appendOwner}, opt principal "rrkah-fqaaa-aaaaa-aaaaq-cai", null, "这是一个测试")'

dfx deploy --with-cycles=5000000000000 --argument '(2, vec {principal "cd7qk-my6ce-anlh6-7wlh5-lw5ry-3ml6o-sjoqg-24cdj-fbryj-7sug2-cqe"; principal "b3ybk-i3254-enljl-hi3ia-hm3d2-drsf4-y6xul-xdl4f-vxxu6-walfx-zqe"; principal "q4ajw-izuff-p4eep-rbigm-4ejrj-er3qd-2ank7-c3pfs-nrvpd-rbsgk-xqe"})'
# 投票
dfx canister call course05 vote '(0)'
# 添加成员
dfx canister call course05 append_Owner '(principal "53jtl-bfmof-gd6lu-scbdt-ibppm-b6f3o-vfdsr-d7kkb-how6s-4vqj6-nae")'
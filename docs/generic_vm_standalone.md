Due to the complexity of FortiGate image information, the tables below provide the corresponding `listing_resource_version` and `source_id` values for each specific `mp_listing_id`.

These values were checked with the OCI CLI:

```bash
oci compute pic listing list --publisher-name "Fortinet, Inc." --all
oci compute pic version list --listing-id <mp_listing_id> --all
```

## Post-deployment Login

The module exposes login-oriented outputs after `terraform apply`:

| Output | Description |
| --- | --- |
| `instance_id` | OCI instance OCID. FortiGate, FortiProxy, FortiManager, and FortiAnalyzer use this as the initial admin password. |
| `instance_public_ip` | Public IP assigned to the instance. |
| `admin_url` | Product GUI URL. FortiGuest uses `/adminportal/auth/login`; other products use `https://<public_ip>`. |
| `admin_username` | Initial GUI username. |
| `admin_initial_password` | Product-specific first-login password guidance. |
| `admin_login_note` | Additional login notes. |

First-login credentials:

| Product | URL | Username | Initial password |
| --- | --- | --- | --- |
| FortiGate | `https://<public_ip>` | `admin` | OCI instance OCID |
| FortiProxy | `https://<public_ip>` | `admin` | OCI instance OCID |
| FortiManager | `https://<public_ip>` | `admin` | OCI instance OCID |
| FortiAnalyzer | `https://<public_ip>` | `admin` | OCI instance OCID |
| FortiGuest | `https://<public_ip>/adminportal/auth/login` | `admin` | No password on first GUI login |
| FortiAIOps 2.x | `https://<public_ip>` | `admin` | `admin` for GUI |
| FortiAIOps 3.x | `https://<public_ip>` | `admin` | No password on first GUI login |

FortiGuest example:

```text
URL:      https://<public_ip>/adminportal/auth/login
Username: admin
Password: no password is required on first GUI login
```

FortiGuest prompts you to set a new GUI password after the first login. The FortiGuest GUI admin login and CLI admin login are different credentials.

FortiAIOps 2.x uses different GUI and CLI admin credentials: the GUI default is `admin/admin`, while the CLI default is `admin` with no password and prompts for a password change. FortiAIOps 3.x uses `admin` with no password for the first GUI login.

## FortiProxy

FortiProxy deployments on OCI use a custom image imported from the Fortinet-provided image file. Set `product_name = "fortiproxy"` and set `source_id` to the OCID of the imported FortiProxy image. Marketplace fields such as `mp_listing_id` and `listing_resource_version` are not required for FortiProxy.

Unlike FortiManager, FortiAnalyzer, FortiGuest, and FortiAIOps, this module does not derive a FortiProxy `source_id` from `product_name` and `image_version`. FortiProxy is deployed from an OCI custom image:

1. Download the FortiProxy OCI/KVM image package from Fortinet Support. The file name is typically similar to `FPX_KVM_OPC-vX-buildXXXX-FORTINET.out.kvm.zip`.
2. Extract the package. The image file used by OCI is `fortiproxy.qcow2`.
3. Upload `fortiproxy.qcow2` to an OCI Object Storage bucket in the target compartment.
4. Import the uploaded object as an OCI custom image. Use image type `QCOW2`; `PARAVIRTUALIZED` launch mode is recommended for this module.
5. Wait until the imported custom image is `AVAILABLE`.
6. Put the imported image OCID into `terraform.tfvars` as `source_id`.

Example FortiProxy block:

```hcl
product_name    = "fortiproxy"
source_id       = "ocid1.image.oc1.<region>.<your_imported_fortiproxy_image_ocid>"
instance_cpu    = 2
instance_memory = 16
instance_shape  = "VM.Standard.E3.Flex"
```

Example OCI CLI flow:

```bash
unzip FPX_KVM_OPC-vX-buildXXXX-FORTINET.out.kvm.zip
oci os bucket create \
  --compartment-id <compartment_ocid> \
  --name <bucket_name> \
  --public-access-type NoPublicAccess
oci os object put \
  --bucket-name <bucket_name> \
  --name fortiproxy.qcow2 \
  --file fortiproxy.qcow2
oci compute image import from-object \
  --compartment-id <compartment_ocid> \
  --namespace <object_storage_namespace> \
  --bucket-name <bucket_name> \
  --name fortiproxy.qcow2 \
  --display-name fortiproxy-custom-image \
  --launch-mode PARAVIRTUALIZED \
  --source-image-type QCOW2 \
  --operating-system FortiProxy
```

## FortiGate Next-Gen Firewall (BYOL)

| mp_listing_id (applies to all rows): `ocid1.appcataloglisting.oc1..aaaaaaaam7ewzrjbltqiarxukuk72v2lqkdtpqtwxqpszqqvrm7likfnpt5q` |
| listing_resource_version | source_id |
| --- | --- |
| 7.6.4_(_X64_) | ocid1.image.oc1..aaaaaaaa6sh4hz4ziatjmda262htabajhihetqgli22mnfyksxjly7gy26gq |
| 7.6.3_(_X64_) | ocid1.image.oc1..aaaaaaaapsgghvaxb7wpmrsknhn5xhpophzmuqsv5bsh6w2x2o26f7cb753q |
| 7.6.3_(_ARM64_) | ocid1.image.oc1..aaaaaaaafgr2rx3n6s5z5jo7rlfy7tnrceb7vrqzppk7ggambtbad6ved6ua |
| 7.6.2_(_ARM64_) | ocid1.image.oc1..aaaaaaaaotkztfkkporunhhzvhjmr4sxrha72zpziiz2iedclt27esbpqs5a |
| 7.4.9_(_ARM64_) | ocid1.image.oc1..aaaaaaaadjbuji7ltjrimr3d5yfavmugkdpmex2nh7wxpvdq7mvivfmtrjtq |
| 7.4.9_(_X64_) | ocid1.image.oc1..aaaaaaaa3jzlu266v4duvkvu4l5lziu3rhpfyjj2vofbpptswmkog3nccehq |
| 7.4.8_(_ARM64_) | ocid1.image.oc1..aaaaaaaal5pyfhxjb7imbdtftxwexfg237pwgefy23idjds7th62ltnboctq |
| 7.4.8_(_X64_) | ocid1.image.oc1..aaaaaaaashmz5wtows3no5ghone3gujr77zhotjtqucwdqjx5tmx4stdaajq |
| 7.4.2_(_ARM64_) | ocid1.image.oc1..aaaaaaaalmipldxavqwtaogyaxwlyv6aa6ijviqt4x4dqpl2wmvnzjuiuwda |
| 7.4.2_(_X64_) | ocid1.image.oc1..aaaaaaaaydhtoikm7qitqvsuhq435asbcggdhp6vwook73ct4b3h7yqigo3a |
| 7.4.1_(_ARM64_) | ocid1.image.oc1..aaaaaaaa2j4uulmmjfgxaxy6iraova6xgywpkntrto74f2y5ybvhkgsre2ya |
| 7.4.1_(_X64_) | ocid1.image.oc1..aaaaaaaatsmx65otmito3afkmqu2k64wodjjlo4shslycoh4amdzntzc2xxq |
| 7.2.12_(_ARM64_) | ocid1.image.oc1..aaaaaaaavqysfhn2obbjsz3s6nakflxg2eiddmgri7l3hm7r2u5tfeghuwfq |
| 7.2.12_(_X64_) | ocid1.image.oc1..aaaaaaaae3zcq3giqyaokptwpgnwsrojgy7gzpmnjxj7yo22lvsljpd2zmva |
| 7.2.11_(_ARM64_) | ocid1.image.oc1..aaaaaaaayq44yaexyrz3mjruosbmp5slzh5gi3citrrix64oj5e3o6lvwncq |
| 7.2.11_(_X64_) | ocid1.image.oc1..aaaaaaaaykvpep2tcvvrphrms4fyilzpcslvx4kbkdhven32kuexdo5oltqq |
| 7.2.7_(_X64_) | ocid1.image.oc1..aaaaaaaaaik2qerbqxtzsv3f3tnrz7fv5exj3ipvxblti2a5tybyra26udrq |
| 7.2.7_(_ARM64_) | ocid1.image.oc1..aaaaaaaal273ephvvqbedzno5baogs734myk6imiisskaw23ojgp3bbpaqmq |
| 7.2.6_(_X64_) | ocid1.image.oc1..aaaaaaaayemuikjhe64ns25jxggllgu7qkkrkxd6y3b664fmz3j7ugj322pa |
| 7.2.6_(_ARM64_) | ocid1.image.oc1..aaaaaaaa5nqbas55ltis7temmkbfwdzrnrmowxluym65lwygg3yghnzx325q |
| 7.2.5_(_X64_) | ocid1.image.oc1..aaaaaaaalj3fxkjxnru4i5725rl45iur3ducp5fy5dmulwzjtepathmtxbta |
| 7.2.5_(_ARM64_) | ocid1.image.oc1..aaaaaaaafsntkbm53wdbtlierphb4ib5y5uodozikkraqoad27g7jgnbxsga |
| 7.2.4_(_ARM64_) | ocid1.image.oc1..aaaaaaaa7sz3jyswp5dkgozvsvpfmmsihgk5qyvidv2br35emtxuqsyenena |
| 7.2.4_(_X64_) | ocid1.image.oc1..aaaaaaaa5m67jbvb33hoxpefr7fhfhf7gaeie4xjg7p4heixg25osr5warcq |
| 7.2.3_(_X64_) | ocid1.image.oc1..aaaaaaaatgr6fgvzztpmmb2tuka55uasrviedqfnksbbwscj3nvhhcxiglba |
| 7.0.17_(_ARM64_) | ocid1.image.oc1..aaaaaaaan7rmtii3sum2ifrli4au6ahf7fe7ieowueojkjkleqmsf7whtmia |
| 7.0.17_(_X64_) | ocid1.image.oc1..aaaaaaaaf6midpco2fwyamddruayonhavc6evwqbvpn5qapgtitn7ux4aofa |
| 7.0.12_(_X64_) | ocid1.image.oc1..aaaaaaaas6sdsatjn22z6d65b6qsoc6e2a23ftoi6nsjivqwhdcflywiljwa |
| 7.0.11_(_X64_) | ocid1.image.oc1..aaaaaaaajvkggybrfj2h2s22fgjyhnsuh4emtrseajftf2btu2mpjwafcn6a |
| 7.0.10_(_X64_) | ocid1.image.oc1..aaaaaaaax3mp33jftx2qftzobwlr3uzinfcglfoopqwp2ovkdj6yx4hjxlyq |
| 6.4.13_(_X64_) | ocid1.image.oc1..aaaaaaaadl6edu6ropr3ffciylgukebdsdgqmnqv2sxvx5e4tactr65ss6vq |
| 6.4.12_(_X64_) | ocid1.image.oc1..aaaaaaaaauzumgqjvznshfpjvdlkpn6zy6fgpyr5u7hmvm2vonfua55yetoa |
| 6.4.11_SR-IOV_Paravirtualized_Mode | ocid1.image.oc1..aaaaaaaavywxh3klmilpuahdv7vmk45sa2z3yky7j33svdp6fk73sdzczkra |
| 6.4.2_SR-IOV_Paravirtualized_Mode | ocid1.image.oc1..aaaaaaaa7nzyf5boguhfwaj7v6bdy3endovdsvzy2i7rnsavq2367krdazsq |

## FortiGate Next-Gen Firewall (2 cores)

| mp_listing_id (applies to all rows): `ocid1.appcataloglisting.oc1..aaaaaaaaif6zctibx6njnmob2a23l5if7voquhgsfqxi2ftog2yy3jxmuaba` |
| listing_resource_version | source_id |
| --- | --- |
| 7.6.4_(_X64_) | ocid1.image.oc1..aaaaaaaawynwkn2pks4wjebr65ctxdfl6l6sqym3hvkij4s45ayot4jzzxuq |
| 7.6.3_(_ARM64_) | ocid1.image.oc1..aaaaaaaa4d5tlhwiml6pyn23nrdevxgut3ppqfskg4zsmivc6x6cncyonxoq |
| 7.6.3_(_X64_) | ocid1.image.oc1..aaaaaaaavegh2evlmlijtjkp4q3isfql5y67nqzzhqjo3ck4vuxngaqyflma |
| 7.6.2_(_ARM64_) | ocid1.image.oc1..aaaaaaaa3l2hccedygfpml7tkmmzdzwz2fpfxmd6gazhjczvf6c6s77lkidq |
| 7.4.9_(_X64_) | ocid1.image.oc1..aaaaaaaaqla3waj3lpy6xirop5vivep35d66sqpqstjtrt5diff3cydonmja |
| 7.4.9_(_ARM64_) | ocid1.image.oc1..aaaaaaaarf677hv6jv5hgzjmdpz6dzowrv6tlyh3db2cz7fnwnwcm4cawcya |
| 7.4.8_(_ARM64_) | ocid1.image.oc1..aaaaaaaam2yjhl3etkyvjdsvjdf4yrpl2pnhss6ez4woyd4ktd5hiuuqvsaq |
| 7.4.8_(_X64_) | ocid1.image.oc1..aaaaaaaayveqayo24foiwkod4rsiyo7zgori7db57xregc2uippquz5z2f5a |
| 7.2.12_(_ARM64_) | ocid1.image.oc1..aaaaaaaafr2ldaozytlu3lbsajcje3bgkycdapxsptpd56nnhllget2v2rfq |
| 7.2.12_(_X64_) | ocid1.image.oc1..aaaaaaaabmsgzvq2bom4vc7wppngojh6vgfasb7vf2gt52rjjkwcdq7brm4a |
| 7.2.11_(_ARM64_) | ocid1.image.oc1..aaaaaaaammfpukeqg72wsz6lpyh7rl2wr7cvhuw4o6e647wrgg4nyduaqpmq |
| 7.2.11_(_X64_) | ocid1.image.oc1..aaaaaaaapld4chzrp26jznebwwjsmx35anp4lx4xzzs33cobt7ds6kntp6eq |
| 7.2.9_(_ARM64_) | ocid1.image.oc1..aaaaaaaasenwafwzmsonqhawjbe3kii3dhlwgdpqzc2lbkx7nwjvzeonk3fa |
| 7.2.4_(_ARM64_)__1 | ocid1.image.oc1..aaaaaaaapjn7tgaoynnz7mkmccnxftzf5ipuru7uo2qeskgqtscmtl5ow5zq |
| 7.2.4_(_X64_) | ocid1.image.oc1..aaaaaaaakwvq3tr5lmmadug5h27byzqdtl3arp4atnrb6wvnpu7spf43zcda |
| 7.2.3_(_X64_) | ocid1.image.oc1..aaaaaaaa2ufmdc65fcfgwa7totfdb3ary4xwrwyoprodb5bqz2fxmqpxozda |
| 7.0.17_(_ARM64_) | ocid1.image.oc1..aaaaaaaateytdevccjxkn45gij3kkeusgtsxmkwlzcnqdoxu3rjivdjmqvoa |
| 7.0.17_(_X64_) | ocid1.image.oc1..aaaaaaaalpddbyumhik2gjtptjk7aocu7kjbmbgezvvl4vc5gmrqamrvoexq |
| 7.0.12_(_X64_) | ocid1.image.oc1..aaaaaaaals6r6k34ubxoap4zjy4ktzi672jveqzwrkueybgwnledwn4iytdq |
| 7.0.11_(_X64_) | ocid1.image.oc1..aaaaaaaaf77ieaobtkvndibyvmzkh7u77ulusjm7axfj47m24kmdxzbgwg4a |
| 7.0.10_(_X64_) | ocid1.image.oc1..aaaaaaaahv4kc47ie5s3wnhfoyetjyrxfaquznkx4wi4wd2ipebpqh37s6iq |
| 6.4.13_(_X64_) | ocid1.image.oc1..aaaaaaaagwolr63cef7e3xb5236mgamopf4nydsdsdl6ce2z3gy7itai3f7q |
| 6.4.12_(_X64_) | ocid1.image.oc1..aaaaaaaaldokcj44zz33oq33moad23d46pr64cah6es7462krieanl7y443q |

## FortiGate Next-Gen Firewall (2 cores, additional listing)

| mp_listing_id (applies to all rows): `ocid1.appcataloglisting.oc1..aaaaaaaadlpx7j46u3iqsiwufaja42vgqg5ohqivneumwdt52dbpm6ab5m4q` |
| listing_resource_version | source_id |
| --- | --- |
| 7.0.5_SR-IOV_Paravirtualized_Mode | ocid1.image.oc1..aaaaaaaawgn5temqec6xugvkkjq2jkfajize4xfqhuqjdqas5f7xoos4uaeq |
| 7.0.3_SR-IOV_Paravirtualized_Mode | ocid1.image.oc1..aaaaaaaadoubmucy7flxsyjjimt2xncslwiobazjczliybpknds7uexx6lva |
| 6.4.8_SR-IOV_Paravirtualized_Mode | ocid1.image.oc1..aaaaaaaag3aamydntyvzhrdmbwiwqqdgbmjkt4cna4g2gjkq35qmr53wut5q |
| 6.4.7_SR-IOV_Paravirtualized_Mode | ocid1.image.oc1..aaaaaaaaqr4ewoasigo2jte7lbzfbhy3hd3vveei6r7znky5woexmb2pbpjq |
| 6.4.2_SR-IOV_Paravirtualized_Mode | ocid1.image.oc1..aaaaaaaa46ac7zbkqoepwgpp5bnmppqfiz66nozkbgwewp6zxsrnsrzytg5a |
| 6.2.5_SR-IOV_Paravirtualized_Mode | ocid1.image.oc1..aaaaaaaa7vsxsxkqziaqac4fmbbmphyepexbmnbnzoku745ccfrfn4dam2aa |
| 6.2.3_SR-IOV_Paravirtualized_Mode | ocid1.image.oc1..aaaaaaaaa3ya24wngpriieo2dfsf4toasetzdkbybgc6gclpnte67zua3gkq |

## FortiGate Next-Gen Firewall (4 cores)

| mp_listing_id (applies to all rows): `ocid1.appcataloglisting.oc1..aaaaaaaabepjdf2sw2jkr77a7zrbog7ukzxepoexzgkoyvbw2j2jn7l4y7lq` |
| listing_resource_version | source_id |
| --- | --- |
| 7.6.4_(_X64_) | ocid1.image.oc1..aaaaaaaa6qqlsuqbpezqqzlrldld4hfhjjw7lkedfwhtmnx4lp2q7tptytaa |
| 7.6.3_(_ARM64_) | ocid1.image.oc1..aaaaaaaawka3nykyrgkb6i5urytfxdy5awwja5qatnj4krhxsy4goaqxubva |
| 7.6.3_(_X64_) | ocid1.image.oc1..aaaaaaaan3lqkje2xpjbakvx642kzmdkudky2wbx3v2j4uizwtvprpa2kelq |
| 7.6.2_(_ARM64_) | ocid1.image.oc1..aaaaaaaab7ihcvowci73k3k5gvwsre52vo3ucxubot2nbqekhpt4rvyuaz7q |
| 7.6.1_(_X64_) | ocid1.image.oc1..aaaaaaaapl4lledlyfxjyrv7owj5ggzjp3bend57fouk4meq4itlqoqb37nq |
| 7.6.1(_ARM64_) | ocid1.image.oc1..aaaaaaaalqqpp5i3wzfemccx54bwzflhbs7cfezlbk4joenibfxmuxdmnh2q |
| 7.4.9_(_X64_) | ocid1.image.oc1..aaaaaaaal2h75734ckxmq5z5vgjbmznqk2ujagpuhdvia6slfsbhldvhakha |
| 7.4.9_(_ARM64_) | ocid1.image.oc1..aaaaaaaawwp3frc6xkoqm6tureogq6annnoegv2vorrk46mlncmv2ymjvoua |
| 7.4.8_(_X64_) | ocid1.image.oc1..aaaaaaaamm3fpf4dv37erexdxumhotwfs2b2fgjwgwqmdpa3ho7lvgwadhwa |
| 7.4.8_(_ARM64_) | ocid1.image.oc1..aaaaaaaao3pfypfcsq6snd6xuuw4ipsk6vhe7gn62awke6bqxsqqwc4wpxqa |
| 7.2.12_(_ARM64_) | ocid1.image.oc1..aaaaaaaaditf5k5bl3yhehwm6vpsw23npkepgrcfsy5bc7sm2icfcnojsjiq |
| 7.2.12_(_X64_) | ocid1.image.oc1..aaaaaaaau5meiqhqkddcm3zlieuog4geivcsds4deghrluqamyrivuz5vmeq |
| 7.2.11_(_ARM64_) | ocid1.image.oc1..aaaaaaaaalmxmsoqj7fuh6s2yp54sv2ec7ppxsjz5o2lwutjiul2ex7rwexq |
| 7.2.11_(_X64_) | ocid1.image.oc1..aaaaaaaaumjhbk6ypr4wiix6n5r675wu2jtb7jk5n3xlrpvtahiilsumizlq |
| 7.0.17_(_ARM64_) | ocid1.image.oc1..aaaaaaaabolwksuxv7re2onws7yxtd7qkgfj7oezuiv6gergkkpstcgwzdhq |
| 7.0.17_(_X64_) | ocid1.image.oc1..aaaaaaaaihvuug2a32izrwzkiydjt3u5ujpciq73in7qqqr2zp6zqudrh3ha |
| 7.0.14_(_ARM64_) | ocid1.image.oc1..aaaaaaaazveboz25woc2ywacke3npfbxhllwrzuq4goo75extkrdtbiftkja |
| 7.0.14_(_X64_) | ocid1.image.oc1..aaaaaaaafwrf734xiguh3wu5x32kbsr5xrgkw4nyw2xdvi47xd4wglditq4a |
| 7.0.12_(_X64_) | ocid1.image.oc1..aaaaaaaa3ft6m3ud364yyokmp6emyrxcf3ibgmmdydcfym4xtuai4wdpv5ba |
| 6.4.13_(_X64_) | ocid1.image.oc1..aaaaaaaae3noptgg5qk4c3uixbk5lyz7bn6wchggqsppihrxal4iiv6f5lma |

## FortiGate Next-Gen Firewall (8 cores)

| mp_listing_id (applies to all rows): `ocid1.appcataloglisting.oc1..aaaaaaaa6e3iscizq3p24bfb5nr4wxsxzc3s6mzpekxgv7f2kse35akhg45q` |
| listing_resource_version | source_id |
| --- | --- |
| 7.6.4_(_X64_) | ocid1.image.oc1..aaaaaaaa253cvjattvnzdkpok4jaur7ujtl7savbtqstzb6mdfrts6tebswq |
| 7.6.3_(_ARM64_) | ocid1.image.oc1..aaaaaaaaw4qqnhbbamq32guagyjqmq4qn3vuc7f75dksahnjjr3pvyoklxka |
| 7.6.3_(_X64_) | ocid1.image.oc1..aaaaaaaanxu3qyjbsai3twbfyh5ce52yqhydj5fia62nrkppp5clkfvwy4ea |
| 7.6.2_(_ARM64_) | ocid1.image.oc1..aaaaaaaazrpacohw7q7uu3w4ko4ftnqbbwgywyw4roiiumya5harlo3bphrq |
| 7.4.9_(_X64_) | ocid1.image.oc1..aaaaaaaa5dbwvlsosqwoizum5ofm5uvnzvpsmkppy4xsoovchkyihaqo243a |
| 7.4.9_(_ARM64_) | ocid1.image.oc1..aaaaaaaaa7uyew2zzfo3ttfcfxr26eugwkmxvjuttxg2rbbdbx7keclq57ra |
| 7.4.8_(_X64_) | ocid1.image.oc1..aaaaaaaafon4ayxkghhufoxe3npywvpgv7bqzp2q4lmwtlmf5nbxqyckhila |
| 7.4.8_(_ARM64_) | ocid1.image.oc1..aaaaaaaahqcdm2trj53xoby6gfbwmtigrea7qj7rh3lgshv4nr6y6bgtmcra |
| 7.4.2_(_ARM64_) | ocid1.image.oc1..aaaaaaaaehrqvxhxhz3tfxnhncap4n574aqzlbshvbqpvaqvuofnoz7q2nra |
| 7.4.2_(_X64_) | ocid1.image.oc1..aaaaaaaa4qkthjuokxnpimykv7exflqjsekxyudzqg4inbw7z6syrcxwzlua |
| 7.4.1_(_ARM64_) | ocid1.image.oc1..aaaaaaaauhev47ghhz33tfnwgsbtfyztimbcnkvyeplzc6ms5ynzww7jifna |
| 7.4.1_(_X64_) | ocid1.image.oc1..aaaaaaaaoelogqceilfn7ovkqdtxlnikgt3arifk27tzwy44i6zqc5dpal4q |
| 7.2.12_(_X64_) | ocid1.image.oc1..aaaaaaaacvzm3nahvpsngpx7o7x4uwcjmmadpxpjrudznrjforzf5drzgt4a |
| 7.2.12_(_ARM64_) | ocid1.image.oc1..aaaaaaaagisaas6f5ji66cvu5xcn3hnzdkz6ke3ol2ku555bbkuu2whn4viq |
| 7.2.11_(_ARM64_) | ocid1.image.oc1..aaaaaaaay6cnyfsbdnwecng6lon6yijrctrpdqmffovlrzhktlz2fobtghuq |
| 7.2.11_(_X64_) | ocid1.image.oc1..aaaaaaaatpuum7cofppenejqy5rhuxp5ni3tmgtf4en7dxae232xn2df5hzq |
| 7.2.9_(_ARM64_) | ocid1.image.oc1..aaaaaaaamdnsrlaisctlq5yomlh6wago7fsjryax5gx4kkdemdtym6rverpa |
| 7.2.9_(_X64_) | ocid1.image.oc1..aaaaaaaaissn7j3mszpaxx62wrhzj7yz7vmxwtr4iiuix2c6tkn7vk3sfafq |
| 7.2.6_(_X64_) | ocid1.image.oc1..aaaaaaaa443pr5hx3g3ourwmhwzjk6gyofy4m2zqg65mxbv7vfowmiebeklq |
| 7.2.6_(_ARM64_) | ocid1.image.oc1..aaaaaaaauqindys6xptloqu6bukqtv35blswquk3t2djjpjjaxokyl3f3pja |
| 7.2.5_(_X64_) | ocid1.image.oc1..aaaaaaaaw53rtk6nepmerbn4czeh3ekshnrrifltf4lr6dxwymjjhjjyscbq |
| 7.2.5_(_ARM64_) | ocid1.image.oc1..aaaaaaaa43d3k5mvqickdi3l76rpmy5sz5ep3sbwc55ml5vsjqkvt6m26dpa |
| 7.2.4_(_ARM64_)__1 | ocid1.image.oc1..aaaaaaaalxgafqty5nbmmgt2w4blyyv7nuw7frzvzm22litnafhbeyueooyq |
| 7.2.4_(_X64_) | ocid1.image.oc1..aaaaaaaaprfqlb4kkpff6ukv6iujzsbjposk36ajic3y54y42tmqhypg2xsq |
| 7.2.3_(_X64_) | ocid1.image.oc1..aaaaaaaar3qypkpwertilhsqwdm3pqywd5va66pxncexmpkkvdoq256h7z6q |
| 7.0.17_(_ARM64_) | ocid1.image.oc1..aaaaaaaajs6gpbenlsl7qasggidfrtzgzathzgebvzd4r7uffqafi264xjma |
| 7.0.17_(_X64_) | ocid1.image.oc1..aaaaaaaadpvtxoh4gl34yiedmg7azwbk6abg4wthu52kpulkhd2xoszlgh7q |
| 7.0.12_(_X64_) | ocid1.image.oc1..aaaaaaaa75pndmzoc3mupred6hec3dn7qqs2ds6vkeok65b4wumdcxptbg4a |
| 7.0.11_(_X64_) | ocid1.image.oc1..aaaaaaaabbk4bzgwvedmdi4aio3aq2c2325a37mex6xiucwsyqhyqgvcpsqq |
| 7.0.10_(_X64_) | ocid1.image.oc1..aaaaaaaa3z654fpg7i6rglo2ge5ryyjwfbpnsrn56cxslcl6dsfxtpr5pwqa |
| 6.4.13_(_X64_) | ocid1.image.oc1..aaaaaaaaxnumvnfauub2u2psg7kopefahxy4idgvlcmuk5pz5ycm2ng25lna |
| 6.4.12_(_X64_) | ocid1.image.oc1..aaaaaaaaxjuzxhc5vdvysbs2nqnzf7tmptap56f75av2fgjtx3j3ffwfozaq |
| 6.4.11_SR-IOV_Paravirtualized_Mode | ocid1.image.oc1..aaaaaaaasxp23cc5oiupl63bfoy57nvye6ay7lnieyxmhsdh76sca6hd6s6q |

## FortiGate Next-Gen Firewall (16 cores)

| mp_listing_id (applies to all rows): `ocid1.appcataloglisting.oc1..aaaaaaaawyxdympmdyxagwj2kr77zybopywouiivxd7vxfttwftkvnw2lqla` |
| listing_resource_version | source_id |
| --- | --- |
| 7.6.4_(_X64_) | ocid1.image.oc1..aaaaaaaanrwk6ajdmtedmw6vlkslhnxnd7qwzarbd2rslruhi5p4jzerwdda |
| 7.6.3_(_ARM64_) | ocid1.image.oc1..aaaaaaaarkhn356m2czpk25qi4dctizkrxwbxbwo47kgna6wd2oxcjyjfqjq |
| 7.6.3_(_X64_) | ocid1.image.oc1..aaaaaaaajy2zldcd7g7h7i6wmqsfvbt4t2ib5tpgs3mhdxmec23egs6wcnoa |
| 7.6.2_(_ARM64_) | ocid1.image.oc1..aaaaaaaavvwscjrdggf2fwivkntvdsgpynn3aox5xsj5wbaseeq3ycrncywa |
| 7.4.9_(_ARM64_) | ocid1.image.oc1..aaaaaaaawrajcygnfwzjo2hfcjrhbnxkzasozmstvyutkyc5xo3skwgncu2q |
| 7.4.9_(_X64_) | ocid1.image.oc1..aaaaaaaa4bto4gkyr3ih4tugcgulr4kilbupvvs6iowohycrgi3nwzinxp2a |
| 7.4.8_(_ARM64_) | ocid1.image.oc1..aaaaaaaar6g4wopzw6imymobqeiz6h4dioulrqdlg22fhjegdhwmabyb2y3a |
| 7.4.8_(_X64_) | ocid1.image.oc1..aaaaaaaacoozagjtio2cjxbplytjclf27er66wxicx32dy7vltwonqrw4wkq |
| 7.4.2_(_ARM64_) | ocid1.image.oc1..aaaaaaaadyuwg4gx7ve5ehwma7pwjs7vv5pglhqomckg7xcdqbwvyv76764a |
| 7.4.2_(_X64_) | ocid1.image.oc1..aaaaaaaajijjfl3bnhursqvguuwqm4ha2bs6a3ovjxho33zj2te2cxq5b36q |
| 7.4.1_(_ARM64_) | ocid1.image.oc1..aaaaaaaac5lnkccyq45hxtwwuxz3qqe5lbhixh2s5fy2uyszj7vvuol66u3q |
| 7.4.1_(_X64_) | ocid1.image.oc1..aaaaaaaad73rr34icct73bjcwzbr3unavzzwtjiw2s5h4phgyhrpigafetga |
| 7.2.12_(_X64_) | ocid1.image.oc1..aaaaaaaagfy6pylkaui5vtg6hhlzuii7kjh7huvglsdahpachrb6i24comxa |
| 7.2.12_(_ARM64_) | ocid1.image.oc1..aaaaaaaa5nzpqltfphejj3b22brhtpti3ggz2iiwecjnflb5rh3xkvuvsvpq |
| 7.2.11_(_X64_) | ocid1.image.oc1..aaaaaaaalr7lwa5mvjxex62qopclcibgsljxy5yl5ptk24ygiq3koxsgvfga |
| 7.2.11_(_ARM64_) | ocid1.image.oc1..aaaaaaaaluott2ejrnyh4cyk5liyhfdwu3qwbv3o3fbnnofdf6qmkwshg2ia |
| 7.2.6_(_X64_) | ocid1.image.oc1..aaaaaaaaaqbesenickabzhg3jcoud76d6ro7e4qqxt55kulctsu7owvaj2mq |
| 7.2.6_(_ARM64_) | ocid1.image.oc1..aaaaaaaadlaftbualh6fb5embff25vuyel5immnxy5ddxebom5tzcuccf46q |
| 7.2.5_(_X64_) | ocid1.image.oc1..aaaaaaaaovnudb63tnrm77d6bdrazisxeidha46hrp6rvs2cfe2e7xxfmpmq |
| 7.2.5_(_ARM64_) | ocid1.image.oc1..aaaaaaaajsuves2lldcwag7yilohwsccalpwi2v2hp4j2lf4todjtklzh5fq |
| 7.2.4_(_ARM64_)__1 | ocid1.image.oc1..aaaaaaaaklhvy4m5bib7ac6ua2osu5nor3cfsy3ugxcailwjushmsokpjktq |
| 7.2.4_(_X64_) | ocid1.image.oc1..aaaaaaaantwwzahhurqldlfimjsr2bl4kbcavn44dor3bxxakz2pecpjeiaa |
| 7.2.3_(_X64_) | ocid1.image.oc1..aaaaaaaae6x32z5hxvduvuombye6h4a3wzubqlwhddyf5tsofm7jl7ovmtzq |
| 7.0.17_(_ARM64_) | ocid1.image.oc1..aaaaaaaa4qn4v7l5kzzbhjmymnvukx3mvak62csftn2bns2he2ycl4pt6pcq |
| 7.0.17_(_X64_) | ocid1.image.oc1..aaaaaaaalvdqrdcy55qml23ggm4zenatkrrvawxjdpmwxq5jjypb5o7aa3na |
| 7.0.12_(_X64_) | ocid1.image.oc1..aaaaaaaatl7qpctzn36i6cs5oihfcghvlyxszbtentgnzxnnwingugwiwnra |
| 7.0.11_(_X64_) | ocid1.image.oc1..aaaaaaaa4wlzfkvywro4h5o4ofcy5nrruvxukv2w6nw2kobohxapvw5btshq |
| 7.0.10_(_X64_) | ocid1.image.oc1..aaaaaaaa5ij5vjlq4scmpw767ubx4x6bxnbrxgubt2snjhtvaafxht7owefq |
| 6.4.13_(_X64_) | ocid1.image.oc1..aaaaaaaapg26lu64nak2apljj3lf6dtpxmbzeoqrnblotz4txt4sjy45ptuq |
| 6.4.12_(_X64_) | ocid1.image.oc1..aaaaaaaaj7s2z2a7alp4llrrthax5kvidukyok7iwvatn4mnqupdomjfm7wa |
| 6.4.11_(_X64_) | ocid1.image.oc1..aaaaaaaax4ovlimyd7mfn7j35oy4t5tzy7fqzt2xsdcsqcs7fw3z234hdyza |

## FortiGate Next-Gen Firewall (24 cores)

| mp_listing_id (applies to all rows): `ocid1.appcataloglisting.oc1..aaaaaaaamc75m7b3rukv6vd573mdrdqnlqabrbhmz5fggvvtalq3ckfl3zqa` |
| listing_resource_version | source_id |
| --- | --- |
| 7.6.4_(_X64_) | ocid1.image.oc1..aaaaaaaaa3xulwhsdlgmvm7eroihoovqtmulatqsnqul4ljjtkhdhmqdjt6q |
| 7.6.3_(_ARM64_) | ocid1.image.oc1..aaaaaaaa2ahgiz7qlhkcqzz5gnivoff6uqbfvhbpm7scwoamj5j2qbay6vwa |
| 7.6.3_(_X64_) | ocid1.image.oc1..aaaaaaaa6tmhjvkyrmg6iwxw67dur2lbhpo6jnqqqyb3mtoge5wyls55x7ua |
| 7.6.2_(_ARM64_) | ocid1.image.oc1..aaaaaaaamlntx323h4r76vwuqa2l6dduq4ma6a3otn6n7ks7ezzetq2koeea |
| 7.4.9_(_X64_) | ocid1.image.oc1..aaaaaaaayacizfybvrkzix3znb54bblrgmg3eyx6njaugswcrym56yrebena |
| 7.4.9_(_ARM64_) | ocid1.image.oc1..aaaaaaaaxwtqpse6c44nrumc4pgvmleqaqeggpov6nhunasnd5qrgiekz63q |
| 7.4.8_(_X64_) | ocid1.image.oc1..aaaaaaaadukflcmalmtmvrxhbhoesyh75z2hn3w5jruj54bcjkcdlxpnfzeq |
| 7.4.8_(_ARM64_) | ocid1.image.oc1..aaaaaaaaqfjiettahkyogmyfbgdpsdgaqlhblt32sk2n5xx3t5vivq354pla |
| 7.4.2_(_ARM64_) | ocid1.image.oc1..aaaaaaaaitk5a64pvazc7keovgvmhcyofzy6327zlj3kvwyhtlairjlz5qvq |
| 7.4.2_(_X64_) | ocid1.image.oc1..aaaaaaaa7hquc4wqt2rdjsaihy3qtewtntu4upa2sp62o2fvdfugm4eerdwq |
| 7.4.1_(_ARM64_) | ocid1.image.oc1..aaaaaaaapy2mo42nnwsga6afw72pi2dckmpn35n3drtbxxxoaxwtrs26ohrq |
| 7.4.1_(_X64_) | ocid1.image.oc1..aaaaaaaamdx3mcrg42x4ytehxlut3utptejjhlu7s33xsgr4xge7lhtw5paa |
| 7.2.12_(_X64_) | ocid1.image.oc1..aaaaaaaavf7ylg3c7yctszyvu4brigsfcokis545jojkzwffco6bew55y7xq |
| 7.2.12_(_ARM64_) | ocid1.image.oc1..aaaaaaaasi3b362gtmfxmjeoo74ea5m4vwmpxpbh5zev4swwchljxrxzpwwa |
| 7.2.11_(_ARM64_) | ocid1.image.oc1..aaaaaaaadbt6lffwotltl67udybgaadnp4spemvd6ne6bhot3g6zumd7peha |
| 7.2.11_(_X64_) | ocid1.image.oc1..aaaaaaaajcl5esdy6mxzftkp2krhqlqe74gmh6lf5vslpo7siymt3cekdncq |
| 7.2.6_(_X64_) | ocid1.image.oc1..aaaaaaaa2qavacgkp5tv3lrzgfr5ra32k7hnueyndznpu7r4zd5qfhex3m5q |
| 7.2.6_(_ARM64_) | ocid1.image.oc1..aaaaaaaa6slgsapddebcrtysp7czb3hxva7fgwkzuf4nxovkwgakdqilseyq |
| 7.2.5_(_X64_) | ocid1.image.oc1..aaaaaaaad3vqrh2fgyxacodujwcev2tiu3rycm2cercacsgvbnldwuj3cmdq |
| 7.2.5_(_ARM64_) | ocid1.image.oc1..aaaaaaaaq76j7dz6nsobizq6psshtp7yazqmhh5bbnuuext2f2ss44ezjp6a |
| 7.2.4_(_ARM64_)__1 | ocid1.image.oc1..aaaaaaaatbsirljfepaged2ev3agx5sgocvui3bvlpfpiues7k5xrb6yhmvq |
| 7.2.4_(_X64_) | ocid1.image.oc1..aaaaaaaasheu2uagj5noi2tx5jkmpanjhyqvfkqxsdnlmwogmxm2mmnm467a |
| 7.2.3_(_X64_) | ocid1.image.oc1..aaaaaaaaksmo2becayfqiutbkjqmquxcdg2rvrqcmise2ow4qmqylzcfjwta |
| 7.0.17_(_X64_) | ocid1.image.oc1..aaaaaaaaf7yshp6b4cgzji5xkwmo3l4n36mblk6dtf2ietnoenhfmi6beppq |
| 7.0.17_(_ARM64_) | ocid1.image.oc1..aaaaaaaablzmtogesp27m6vwmgn72vx5kii74bc2ukwemhet3x64latqptqa |
| 7.0.12_(_X64_) | ocid1.image.oc1..aaaaaaaalcglihji4pmyhhssnoqey7qwssh6qo4exhrsptcpoojr4tu55qna |
| 7.0.11_(_X64_) | ocid1.image.oc1..aaaaaaaaylwkpx2f22apyus3hnbxnnnlop5uloorbeawdmj7ldqnrplp7acq |
| 7.0.10_(_X64_) | ocid1.image.oc1..aaaaaaaamrt4wcqh2apro4bcvrzns2ufz33zgn235koeshczkico2hwug5wa |
| 6.4.13_(_X64_) | ocid1.image.oc1..aaaaaaaas3efqt2belbhjll3hd5pl6szw2gpez5fzipt6pjljq7zt7mkvxna |
| 6.4.12_(_X64_) | ocid1.image.oc1..aaaaaaaac3cvxxcb6vedg5fgpg2oborcidqcmnneapjew6gi2lu466vyhnna |
| 6.4.11_SR-IOV_Paravirtualized_Mode | ocid1.image.oc1..aaaaaaaadz2hci6suz6t6f7eo2uhwyq4wg6i77faeitw5ksawbxcqj7jg7hq |

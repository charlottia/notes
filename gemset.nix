{
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cl2qpvwiffym62z991ynks7imsm87qmgxf0yfsmlwzkgi9qcaa6";
      type = "gem";
    };
    version = "2.8.7";
  };
  adsf = {
    dependencies = [
      "rack"
      "rackup"
    ];
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xay0p2rlknw7ls4zqqbvcfvqylfd6jnjx338qqizymv93hk924n";
      type = "gem";
    };
    version = "1.5.2";
  };
  adsf-live = {
    dependencies = [
      "adsf"
      "em-websocket"
      "eventmachine"
      "listen"
    ];
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0zy12rl0qhj0cmm1q0bshanz260alrsf9zjplmm8l63ldq7lrryx";
      type = "gem";
    };
    version = "1.5.2";
  };
  base64 = {
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0yx9yn47a8lkfcjmigk79fykxvr80r4m1i35q82sxzynpbm7lcr7";
      type = "gem";
    };
    version = "0.3.0";
  };
  builder = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pw3r2lyagsxkm71bf44v5b74f7l9r7di22brbyji9fwz791hya9";
      type = "gem";
    };
    version = "3.3.0";
  };
  coderay = {
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jvxqxzply1lwp7ysn94zjhh57vc14mcshw1ygw14ib8lhc00lyw";
      type = "gem";
    };
    version = "1.1.3";
  };
  commonmarker = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wmdbp84xphmmdr7rnb0mmqd1ip69k7d56sijyv80ph948s2zi4k";
      type = "gem";
    };
    version = "1.0.4";
  };
  concurrent-ruby = {
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ipbrgvf0pp6zxdk5ascp6i29aybz2bx9wdrlchjmpx6mhvkwfw1";
      type = "gem";
    };
    version = "1.3.5";
  };
  cri = {
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rank6i9p2drwdcmhan6ifkzrz1v3mwpx47fwjl75rskxwjfkgwa";
      type = "gem";
    };
    version = "2.15.12";
  };
  ddmetrics = {
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01pd19xi121q15rxccimankzy2jp5w7h7iv0nziz1hn6174fnlgc";
      type = "gem";
    };
    version = "1.1.0";
  };
  ddplugin = {
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14hbvr6qjcn1i6pin8rq9kr02f98imskhrl8k53117mlfxxhl9sv";
      type = "gem";
    };
    version = "1.0.3";
  };
  diff-lcs = {
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qlrj2qyysc9avzlr4zs1py3x684hqm61n4czrsk1pyllz5x5q4s";
      type = "gem";
    };
    version = "1.6.2";
  };
  em-websocket = {
    dependencies = [
      "eventmachine"
      "http_parser.rb"
    ];
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1a66b0kjk6jx7pai9gc7i27zd0a128gy73nmas98gjz6wjyr4spm";
      type = "gem";
    };
    version = "0.5.3";
  };
  eventmachine = {
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wh9aqb0skz80fhfn66lbpr4f86ya2z5rx6gm5xlfhd05bj1ch4r";
      type = "gem";
    };
    version = "1.2.7";
  };
  ffi = {
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04zqcl8lsnxlnvzmffr98p1w78w7z3c45pmqh9viac0xps4rgpal";
      type = "gem";
    };
    version = "1.17.2";
  };
  "http_parser.rb" = {
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gj4fmls0mf52dlr928gaq0c0cb0m3aqa9kaa6l0ikl2zbqk42as";
      type = "gem";
    };
    version = "0.8.0";
  };
  immutable-ruby = {
    dependencies = [
      "concurrent-ruby"
      "sorted_set"
    ];
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rq58r59m2l36qf5l34pn3va47aihyz2kpf3vlhzxhy8v7h9df0s";
      type = "gem";
    };
    version = "0.2.0";
  };
  json_schema = {
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nzcnb9j7bbj3nc6izwlsxky8j4xly345qzfg5v5n6550kqfmqfn";
      type = "gem";
    };
    version = "0.21.0";
  };
  listen = {
    dependencies = [
      "rb-fsevent"
      "rb-inotify"
    ];
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rwwsmvq79qwzl6324yc53py02kbrcww35si720490z5w0j497nv";
      type = "gem";
    };
    version = "3.9.0";
  };
  logger = {
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00q2zznygpbls8asz5knjvvj2brr3ghmqxgr83xnrdj4rk3xwvhr";
      type = "gem";
    };
    version = "1.7.0";
  };
  memo_wise = {
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0sviicsh5siay8flm7ipqs8jrp34hv2m6df7kf211x6fqhw0q8ih";
      type = "gem";
    };
    version = "1.13.0";
  };
  method_source = {
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1igmc3sq9ay90f8xjvfnswd1dybj1s3fi0dwd53inwsvqk4h24qq";
      type = "gem";
    };
    version = "1.1.0";
  };
  nanoc = {
    dependencies = [
      "addressable"
      "nanoc-checking"
      "nanoc-cli"
      "nanoc-core"
      "nanoc-deploying"
      "parallel"
      "tty-command"
      "tty-which"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vhxfcad3mklsr2g1wn0v4mvqlqf755f8znmx2sd2fy3b3a16mfr";
      type = "gem";
    };
    version = "4.13.5";
  };
  nanoc-checking = {
    dependencies = [
      "nanoc-cli"
      "nanoc-core"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10flpmai8iy7n0d5pci8bpv6z0114aidyxrc107miabmribkq7fx";
      type = "gem";
    };
    version = "1.0.6";
  };
  nanoc-cli = {
    dependencies = [
      "cri"
      "diff-lcs"
      "logger"
      "nanoc-core"
      "pry"
      "zeitwerk"
    ];
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1c49yqbafnhxnwfbcafq82z3njp0hkzkansgff61sdb0ysvhknsn";
      type = "gem";
    };
    version = "4.13.5";
  };
  nanoc-core = {
    dependencies = [
      "base64"
      "concurrent-ruby"
      "ddmetrics"
      "ddplugin"
      "immutable-ruby"
      "json_schema"
      "memo_wise"
      "slow_enumerator_tools"
      "tty-platform"
      "zeitwerk"
    ];
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hlgqy5xxq4cyrz9brb5zhj8rwi2xz87hjbd5q94x3n73fhxsv4i";
      type = "gem";
    };
    version = "4.13.5";
  };
  nanoc-deploying = {
    dependencies = [
      "nanoc-checking"
      "nanoc-cli"
      "nanoc-core"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05s3aqdb7li97lzj5qpak8iac2nfhggv5s23wmzmgzm16c7fkcw9";
      type = "gem";
    };
    version = "1.0.2";
  };
  nanoc-live = {
    dependencies = [
      "adsf-live"
      "listen"
      "nanoc-cli"
      "nanoc-core"
    ];
    groups = [ "nanoc" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1pagaz3yr50xv64f3bj948ffiqm8vbj71zf5rb2n0sgakh6yqsqi";
      type = "gem";
    };
    version = "1.1.0";
  };
  nokogiri = {
    dependencies = [ "racc" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0y9rfr54sg7n4hx0mk5k3bdd0j297h1qhnzzsc4n7zv3ckqg38zf";
      type = "gem";
    };
    version = "1.18.9";
  };
  parallel = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0c719bfgcszqvk9z47w2p8j2wkz5y35k48ywwas5yxbbh3hm3haa";
      type = "gem";
    };
    version = "1.27.0";
  };
  pastel = {
    dependencies = [ "tty-color" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xash2gj08dfjvq4hy6l1z22s5v30fhizwgs10d6nviggpxsj7a8";
      type = "gem";
    };
    version = "0.8.0";
  };
  pry = {
    dependencies = [
      "coderay"
      "method_source"
    ];
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ssv704qg75mwlyagdfr9xxbzn1ziyqgzm0x474jkynk8234pm8j";
      type = "gem";
    };
    version = "0.15.2";
  };
  public_suffix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1543ap9w3ydhx39ljcd675cdz9cr948x9mp00ab8qvq6118wv9xz";
      type = "gem";
    };
    version = "6.0.2";
  };
  racc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0byn0c9nkahsl93y9ln5bysq4j31q8xkf2ws42swighxd4lnjzsa";
      type = "gem";
    };
    version = "1.8.1";
  };
  rack = {
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0da64fq3w671qhp7ji1zs84m5lyhalq4khqhbfw5dz0y6mn61dgg";
      type = "gem";
    };
    version = "3.1.16";
  };
  rackup = {
    dependencies = [ "rack" ];
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13brkq5xkj6lcdxj3f0k7v28hgrqhqxjlhd4y2vlicy5slgijdzp";
      type = "gem";
    };
    version = "2.2.1";
  };
  rb-fsevent = {
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zmf31rnpm8553lqwibvv3kkx0v7majm1f341xbxc0bk5sbhp423";
      type = "gem";
    };
    version = "0.11.2";
  };
  rb-inotify = {
    dependencies = [ "ffi" ];
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vmy8xgahixcz6hzwy4zdcyn2y6d6ri8dqv5xccgzc1r292019x0";
      type = "gem";
    };
    version = "0.11.1";
  };
  rbtree = {
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1z0h1x7fpkzxamnvbw1nry64qd6n0nqkwprfair29z94kd3a9vhl";
      type = "gem";
    };
    version = "0.4.6";
  };
  rouge = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ynxxmvzczn9a6wd87jyh209590nq6f6ls55dmwiky8fvwi8c68h";
      type = "gem";
    };
    version = "4.6.0";
  };
  set = {
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wcfdmj162d1ydka5wbnan3kj5jv6494qpaav50q0y1f406sccya";
      type = "gem";
    };
    version = "1.1.2";
  };
  slow_enumerator_tools = {
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0phfj4jxymxf344cgksqahsgy83wfrwrlr913mrsq2c33j7mj6p6";
      type = "gem";
    };
    version = "1.1.0";
  };
  sorted_set = {
    dependencies = [
      "rbtree"
      "set"
    ];
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0brpwv68d7m9qbf5js4bg8bmg4v7h4ghz312jv9cnnccdvp8nasg";
      type = "gem";
    };
    version = "1.0.3";
  };
  tty-color = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0aik4kmhwwrmkysha7qibi2nyzb4c8kp42bd5vxnf8sf7b53g73g";
      type = "gem";
    };
    version = "0.6.0";
  };
  tty-command = {
    dependencies = [ "pastel" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14hi8xiahfrrnydw6g3i30lxvvz90wp4xsrlhx8mabckrcglfv0c";
      type = "gem";
    };
    version = "0.10.1";
  };
  tty-platform = {
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02h58a8yg2kzybhqqrhh4lfdl9nm0i62nd9jrvwinjp802qkffg2";
      type = "gem";
    };
    version = "0.3.0";
  };
  tty-which = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rpljdwlfm4qgps2xvq6306w86fm057m89j4gizcji371mgha92q";
      type = "gem";
    };
    version = "0.5.0";
  };
  zeitwerk = {
    groups = [
      "default"
      "nanoc"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "119ypabas886gd0n9kiid3q41w76gz60s8qmiak6pljpkd56ps5j";
      type = "gem";
    };
    version = "2.7.3";
  };
}

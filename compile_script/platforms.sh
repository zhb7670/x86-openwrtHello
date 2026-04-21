#!/bin/bash

# ============================================================
# X86-Only OpenWrtAction - platforms.sh
# 只编译 X86 设备，支持三个源码平台
# ============================================================

source_code_platforms=(openwrt immortalwrt lede)

# 各平台源码信息
openwrt_value='{"REPO_URL": "https://github.com/openwrt/openwrt.git","REPO_BRANCH": "openwrt-25.12","CONFIGS": "config/openwrt_config","DIY_P1_SH": "diy_script/openwrt_diy/diy-part1.sh","DIY_P2_SH": "diy_script/openwrt_diy/diy-part2.sh","DIY_P3_SH": "diy_script/openwrt_diy/diy-part3.sh","OS": "ubuntu-latest"}'

immortalwrt_value='{"REPO_URL": "https://github.com/immortalwrt/immortalwrt.git","REPO_BRANCH": "openwrt-25.12","CONFIGS": "config/immortalwrt_config","DIY_P1_SH": "diy_script/immortalwrt_diy/diy-part1.sh","DIY_P2_SH": "diy_script/immortalwrt_diy/diy-part2.sh","DIY_P3_SH": "diy_script/immortalwrt_diy/diy-part3.sh","OS": "ubuntu-latest"}'

lede_value='{"REPO_URL": "https://github.com/coolsnowwolf/lede.git","REPO_BRANCH": "master","CONFIGS": "config/leanlede_config","DIY_P1_SH": "diy_script/lean_diy/diy-part1.sh","DIY_P2_SH": "diy_script/lean_diy/diy-part2.sh","DIY_P3_SH": "diy_script/lean_diy/diy-part3.sh","OS": "ubuntu-latest"}'

# ============================================================
# ★★★ X86 only - 只保留 X86 ★★★
# ============================================================
openwrt_platforms=(X86)
immortalwrt_platforms=(X86)
lede_platforms=(X86)

# 构建矩阵（源码 + 平台）
matrix_json="["
source_matrix_json="["

for source_platform in "${source_code_platforms[@]}"; do
    platforms_var="${source_platform}_platforms[@]"
    platforms=("${!platforms_var}")
    value_var="${source_platform}_value"
    value="${!value_var}"

    source_matrix_json+="{\"source_code_platform\":\"${source_platform}\",\"value\":${value}},"

    for platform in "${platforms[@]}"; do
        matrix_json+="{\"source_code_platform\":\"${source_platform}\",\"platform\":\"${platform}\",\"value\":${value}},"
    done
done

matrix_json="${matrix_json%,}]"
source_matrix_json="${source_matrix_json%,}]"

echo "matrix=$matrix_json" >> $GITHUB_OUTPUT
echo "source_matrix_json=$source_matrix_json" >> $GITHUB_OUTPUT

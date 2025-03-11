# /usr/bin/env python3
import os
import shutil
import subprocess
import platform
import re


def get_os_distro():
    distro = ""
    try:
        with open("/etc/os-release", "r") as f:
            for line in f:
                if re.match(r"^ID=", line):
                    distro = line.strip().split("=", 1)[1].strip().strip('"')
    except Exception as e:
        print("Cannot read /etc/os-release :", e)
    return distro


def change_default_shell():
    # Check if zsh was intalled in system
    zsh_path = shutil.which("zsh")
    if not zsh_path:
        print(
            "Error: zsh is not installed on the system. Please install zsh first and then run this script."
        )
    return

    # Get the current user's username
    try:
        username = os.getlogin()
    except Exception:
        import pwd

        username = pwd.getpwuid(os.getuid())[0]

    # 使用 chsh 命令更改默认 shell
    try:
        # 注意：修改默认 shell 可能需要密码验证
        subprocess.run(["chsh", "-s", zsh_path, username], check=True)
        print(f"默认 shell 已成功修改为 {zsh_path}")
    except subprocess.CalledProcessError as e:
        print("更改默认 shell 失败，请手动更改。")
        print(e)


def copy_file(src, dest):
    """复制单个文件，并保留权限"""
    try:
        os.makedirs(os.path.dirname(dest), exist_ok=True)
        shutil.copy2(src, dest)
        print(f"复制文件：{src} -> {dest}")
    except Exception as e:
        print(f"复制文件 {src} 时出错：{e}")


def copy_directory(src, dest):
    """复制整个目录。如果目标目录已存在，则进行合并更新文件。"""
    try:
        if not os.path.exists(dest):
            shutil.copytree(src, dest)
            print(f"复制目录：{src} -> {dest}")
        else:
            # 如果目标目录已存在，则递归复制所有文件
            for root, dirs, files in os.walk(src):
                rel_path = os.path.relpath(root, src)
                target_dir = os.path.join(dest, rel_path)
                os.makedirs(target_dir, exist_ok=True)
                for file in files:
                    src_file = os.path.join(root, file)
                    dest_file = os.path.join(target_dir, file)
                    shutil.copy2(src_file, dest_file)
                    print(f"更新文件：{src_file} -> {dest_file}")
    except Exception as e:
        print(f"复制目录 {src} 时出错：{e}")


def install_configs():
    """
    根据配置文件目录结构，将配置文件复制到：
    - 用户根目录：.bashrc, .profile, .vim, .vimrc, .zshenv, .zshrc 等
    - ~/.config 目录：btop, gdb, kitty, nvim, starship, vale, zsh 等
    """
    # 当前脚本所在目录，即配置仓库目录
    repo_dir = os.path.abspath(os.path.dirname(__file__))
    home_dir = os.path.expanduser("~")
    config_dir = os.path.join(home_dir, ".config")

    # 需要复制到 home 根目录的文件/目录（这里仅作为示例，你可以根据需要调整）
    home_items = [".bashrc", ".profile", ".vim", ".vimrc", ".zshenv", ".zshrc"]

    # 需要复制到 ~/.config 目录下的配置目录
    config_items = ["btop", "gdb", "kitty", "nvim", "starship", "vale", "zsh"]

    print("开始安装配置文件...")

    # 复制根目录配置
    for item in home_items:
        src_path = os.path.join(repo_dir, item)
        dest_path = os.path.join(home_dir, item)
        if os.path.exists(src_path):
            # 如果是目录，使用 copytree 或者递归复制文件；如果是文件则直接复制
            if os.path.isdir(src_path):
                copy_directory(src_path, dest_path)
            else:
                copy_file(src_path, dest_path)
        else:
            print(f"警告：{src_path} 不存在。")

    # 复制 ~/.config 下的配置项
    for item in config_items:
        src_path = os.path.join(repo_dir, item)
        dest_path = os.path.join(config_dir, item)
        if os.path.exists(src_path):
            if os.path.isdir(src_path):
                copy_directory(src_path, dest_path)
            else:
                copy_file(src_path, dest_path)
        else:
            print(f"警告：{src_path} 不存在。")

    print("配置文件安装完成！")


def main():
    os_name = platform.system()
    os_distro = get_os_distro()
    change_default_shell()
    install_configs()


if __name__ == "__main__":
    main()

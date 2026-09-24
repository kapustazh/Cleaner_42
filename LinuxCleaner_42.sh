#!/bin/bash
#Author Omar BOUYKOURNE updated by Anas AAMMARI to support linux
#42login : obouykou, 42login : aaammari


#banner
echo -e	"\n"
echo -e	" 		█▀▀ █▀▀ █░░ █▀▀ ▄▀█ █▄░█ "
echo -e	" 		█▄▄ █▄▄ █▄▄ ██▄ █▀█ █░▀█ "
echo -en "\n    	    	   By: "
echo -e "\033[33mOMBHD\033[0m [𝒐𝒃𝒐𝒖𝒚𝒌𝒐𝒖]\n"

sleep 2

#update
if [ "$1" == "update" ];
then
	tmp_dir=".4yarha"
	if ! git clone --quiet https://github.com/kapustazh/Cleaner_42.git "$HOME"/"$tmp_dir" &>/dev/null;
	then
		sleep 0.5
		echo -e "\033[31m\n           -- Couldn't update CCLEAN! :( --\033[0m"
		echo -e "\033[33m\n   -- Maybe you need to change your bad habits XD --\n\033[0m"
		exit 1
	fi
	sleep 1
	if cmp -s "$HOME"/LinuxCleaner_42.sh "$HOME"/"$tmp_dir"/LinuxCleaner_42.sh;
	then
		echo -e "\033[33m\n -- You already have the latest version of cclean --\n\033[0m"
		/bin/rm -rf "$HOME"/"${tmp_dir:?}"
		exit 0
	fi
	cp -f "$HOME"/"$tmp_dir"/Linux_Cleaner_42.sh "$HOME" &>/dev/null
	/bin/rm -rf "$HOME"/"${tmp_dir:?}" &>/dev/null
	echo -e "\033[33m\n -- cclean has been updated successfully --\n\033[0m"
	exit 0
fi

#calculating the current available storage
Storage=$(df -h "$HOME" | grep -E "$(df "$HOME" | tail -1 | awk '{print $1}')" | awk '{print($4)}')
if [ "$Storage" == "0" ];
then
	Storage="0B"
fi
echo -e "\033[33m\n -- Available Storage Before Cleaning : || $Storage || --\033[0m"

echo -e "\033[31m\n -- Cleaning ...\n\033[0m "

should_log=0
dry_run=0
if [[ "$1" == "-p" || "$1" == "--print" ]]; then
	should_log=1
elif [ "$1" == "--dry-run" ]; then
	should_log=1
	dry_run=1
fi

function clean_glob {
	# don't do anything if argument count is zero (unmatched glob).
	if [ -z "$1" ]; then
		return 0
	fi

	if [ $should_log -eq 1 ]; then
		for arg in "$@"; do
			du -sh "$arg" 2>/dev/null
		done
	fi

	[ $dry_run -eq 1 ] && return 0
	/bin/rm -rf "$@" &>/dev/null

	return 0
}

function clean {
	# to avoid printing empty lines
	# or unnecessarily calling /bin/rm
	# we resolve unmatched globs as empty strings.
	shopt -s nullglob

	echo -ne "\033[38;5;208m"

	#42 Caches
	clean_glob "$HOME"/.42*
	clean_glob "$HOME"/.zcompdump*

	#Trash
	clean_glob "$HOME"/.local/share/Trash/files/*
	clean_glob "$HOME"/.local/share/Trash/info/*

	#General Cache files
	clean_glob "$HOME"/.cache/*

	#Package manager caches
	clean_glob "$HOME"/.cache/pip/*
	clean_glob "$HOME"/.npm/_cacache/*
	clean_glob "$HOME"/.npm/_npx/*
	clean_glob "$HOME"/.npm/_logs/*
	clean_glob "$HOME"/.yarn/cache/*
	clean_glob "$HOME"/.cargo/registry/cache/*
	clean_glob "$HOME"/.gem/ruby/*/cache/*
	clean_glob "$HOME"/.mypy_cache/*
	clean_glob "$HOME"/.local/bin/.mypy_cache/*
	clean_glob "$HOME"/.codex/.tmp/*
	clean_glob "$HOME"/.codex/tmp/*
	clean_glob "$HOME"/.codex/cache/*
	clean_glob "$HOME"/.codex/shell_snapshots/*
	clean_glob "$HOME"/.codex/models_cache.json
	clean_glob "$HOME"/.codex/plugins/.remote-plugin-install-staging/*
	clean_glob "$HOME"/.local/bin/*.AppImage.part
	clean_glob "$HOME"/.local/bin/agy.*.old
	clean_glob "$HOME"/.fontconfig/*

	# Steam update staging (only while Steam is closed)
	if ! pgrep -x steam >/dev/null 2>&1; then
		clean_glob "$HOME"/.local/share/Steam/package/tmp
	fi

	#Browser Caches - Firefox
	clean_glob "$HOME"/.var/app/org.mozilla.firefox/cache/*
	clean_glob "$HOME"/.var/app/org.mozilla.firefox/.mozilla/firefox/Crash Reports/*
	clean_glob "$HOME"/.var/app/org.mozilla.firefox/.mozilla/firefox/*.default*/cache2/*
	clean_glob "$HOME"/.var/app/org.mozilla.firefox/.mozilla/firefox/*.default*/startupCache/*
	clean_glob "$HOME"/.var/app/org.mozilla.firefox/.mozilla/firefox/*.default*/OfflineCache/*



	#Browser Caches - Chrome/Chromium (native)
	clean_glob "$HOME"/.config/google-chrome/Default/Cache/*
	clean_glob "$HOME"/.config/google-chrome/Default/Code\ Cache/*
	clean_glob "$HOME"/.config/google-chrome/Default/Service\ Worker/CacheStorage/*
	clean_glob "$HOME"/.config/google-chrome/Default/GPUCache/*
	clean_glob "$HOME"/.config/google-chrome/ShaderCache/*
	clean_glob "$HOME"/.config/google-chrome/GraphiteDawnCache/*
	clean_glob "$HOME"/.config/google-chrome/GrShaderCache/*
	clean_glob "$HOME"/.config/google-chrome/component_crx_cache/*
	clean_glob "$HOME"/.config/google-chrome/optimization_guide_model_store/*

	#Browser Caches - Chrome/Chromium
	clean_glob "$HOME"/.cache/google-chrome/Default/Cache/*
	clean_glob "$HOME"/.var/app/com.google.Chrome/cache/*
	clean_glob "$HOME"/.var/app/com.google.Chrome/config/google-chrome/Default/Service\ Worker/CacheStorage/*
	clean_glob "$HOME"/.var/app/com.google.Chrome/config/google-chrome/Default/Application\ Cache/*
	clean_glob "$HOME"/.var/app/com.google.Chrome/config/google-chrome/Default/File\ System
	clean_glob "$HOME"/.var/app/com.google.Chrome/config/google-chrome/Profile\ [0-9]/Service\ Worker/CacheStorage/*
	clean_glob "$HOME"/.var/app/com.google.Chrome/config/google-chrome/Profile\ [0-9]/Application\ Cache/*
	clean_glob "$HOME"/.var/app/com.google.Chrome/config/google-chrome/Profile\ [0-9]/File\ System

	#Browser Caches - Brave (native)
	clean_glob "$HOME"/.config/BraveSoftware/Brave-Browser/Default/Cache/*
	clean_glob "$HOME"/.config/BraveSoftware/Brave-Browser/Default/Code\ Cache/*
	clean_glob "$HOME"/.config/BraveSoftware/Brave-Browser/Default/Service\ Worker/CacheStorage/*
	clean_glob "$HOME"/.config/BraveSoftware/Brave-Browser/Default/GPUCache/*
	clean_glob "$HOME"/.config/BraveSoftware/Brave-Browser/ShaderCache/*
	clean_glob "$HOME"/.config/BraveSoftware/Brave-Browser/GraphiteDawnCache/*
	clean_glob "$HOME"/.config/BraveSoftware/Brave-Browser/GrShaderCache/*

	#Browser Caches - Brave
	clean_glob "$HOME"/.var/app/com.brave.Browser/cache/*
	clean_glob "$HOME"/.var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/Default/Service\ Worker/CacheStorage/*
	clean_glob "$HOME"/.var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/Default/Application\ Cache/*
	clean_glob "$HOME"/.var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/Default/File\ System
	clean_glob "$HOME"/.var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/Profile\ [0-9]/Service\ Worker/CacheStorage/*
	clean_glob "$HOME"/.var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/Profile\ [0-9]/Application\ Cache/*
	clean_glob "$HOME"/.var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/Profile\ [0-9]/File\ System
	clean_glob "$HOME"/.cache/brave/Default/Cache/*


	#Application Caches
	clean_glob "$HOME"/.var/app/com.visualstudio.code/cache/*
	clean_glob "$HOME"/.var/app/com.visualstudio.code/config/Code/Cache/*
	clean_glob "$HOME"/.var/app/com.visualstudio.code/config/Code/CachedData/*
	clean_glob "$HOME"/.var/app/com.visualstudio.code/config/Code/User/workspaceStorage/*
	clean_glob "$HOME"/.var/app/com.visualstudio.code/config/Code/Crashpad/completed/*

	#VS Code (native) caches
	clean_glob "$HOME"/.config/Code/Cache/*
	clean_glob "$HOME"/.config/Code/CachedData/*
	clean_glob "$HOME"/.config/Code/CachedExtensionVSIXs/*
	clean_glob "$HOME"/.config/Code/CachedExtensionVSIXs/.trash
	clean_glob "$HOME"/.config/Code/GPUCache/*
	clean_glob "$HOME"/.config/Code/Code\ Cache/*
	clean_glob "$HOME"/.config/Code/Crashpad/completed/*
	clean_glob "$HOME"/.config/Code/logs/*
	clean_glob "$HOME"/.config/Code/User/workspaceStorage/*
	clean_glob "$HOME"/.config/Code.backup

	#Cursor caches (keeps AppImage + extensions)
	clean_glob "$HOME"/.config/Cursor/Cache/*
	clean_glob "$HOME"/.config/Cursor/CachedData/*
	clean_glob "$HOME"/.config/Cursor/CachedExtensionVSIXs/*
	clean_glob "$HOME"/.config/Cursor/GPUCache/*
	clean_glob "$HOME"/.config/Cursor/Code\ Cache/*
	clean_glob "$HOME"/.config/Cursor/Crashpad/completed/*
	clean_glob "$HOME"/.config/Cursor/logs/*
	clean_glob "$HOME"/.config/Cursor/WebStorage/*
	clean_glob "$HOME"/.config/Cursor/User/globalStorage/anysphere.cursor-agent-worker/*
	clean_glob "$HOME"/.config/Cursor/User/workspaceStorage/*
	clean_glob "$HOME"/.config/Cursor/User/History/*
	clean_glob "$HOME"/.cursor/projects/*

	clean_glob "$HOME"/.var/app/com.discordapp.Discord/cache/*
	clean_glob "$HOME"/.var/app/com.discordapp.Discord/config/discord/Cache/*
 	clean_glob "$HOME"/.var/app/com.discordapp.Discord/config/discord/Code\ Cache/js*
 	clean_glob "$HOME"/.var/app/com.discordapp.Discord/config/discord/Crashpad/completed/*


	clean_glob "$HOME"/.var/app/com.slack.Slack/cache/*
	clean_glob "$HOME"/.var/app/com.slack.Slack/config/Slack/Cache/*
	clean_glob "$HOME"/.var/app/com.slack.Slack/config/Slack/Service\ Worker/CacheStorage/*
	clean_glob "$HOME"/.var/app/com.slack.Slack/config/Slack/Crashpad/completed/*

	#Slack (native) caches
	clean_glob "$HOME"/.config/Slack/Cache/*
	clean_glob "$HOME"/.config/Slack/Service\ Worker/*
	clean_glob "$HOME"/.config/Slack/Code\ Cache/*
	clean_glob "$HOME"/.config/Slack/GPUCache/*
	clean_glob "$HOME"/.config/Slack/logs/*

    clean_glob "$HOME"/.var/app/com.spotify.Client/cache/*
    clean_glob "$HOME"/.var/app/com.spotify.Client/config/spotify/PersistentCache/*

	#.DS_Store files
	clean_glob "$HOME"/Desktop/**/*/.DS_Store

	#Thumbnails
	clean_glob "$HOME"/.cache/thumbnails/*
	clean_glob "$HOME"/.thumbnails/*

	#Things related to pool (piscine)
	clean_glob "$HOME"/Desktop/Piscine\ Rules\ *.mp4
	clean_glob "$HOME"/Desktop/PLAY_ME.webloc

    # Docker user caches
    clean_glob "$HOME"/.docker/*/cache/*

	#Old Claude Code versions (keep the one ~/.local/bin/claude points to)
	current_claude=$(readlink -f "$HOME/.local/bin/claude" 2>/dev/null)
	for v in "$HOME"/.local/share/claude/versions/*; do
		[ "$v" != "$current_claude" ] && clean_glob "$v"
	done

	#Old Codex standalone releases (keep the one current points to)
	current_codex=$(readlink -f "$HOME/.codex/packages/standalone/current" 2>/dev/null)
	for v in "$HOME"/.codex/packages/standalone/releases/*; do
		[ "$v" != "$current_codex" ] && clean_glob "$v"
	done

	#Old Cursor AppImages (keep the one ~/.local/bin/cursor launches)
	current_cursor=$(grep -oE '[^"]*Cursor[^"]*\.AppImage' "$HOME/.local/bin/cursor" 2>/dev/null | head -1)
	if [ -n "$current_cursor" ]; then
		for img in "$HOME"/.local/bin/Cursor-*.AppImage; do
			[ "$img" != "$current_cursor" ] && clean_glob "$img"
		done
	fi
	clean_glob "$HOME"/.local/bin/Cursor-*.AppImage.zs-old
	clean_glob "$HOME"/.local/bin/Cursor-*.AppImage.part
	if [ -x "$HOME/.local/bin/cursor-agent" ]; then
		current_cursor_agent_dir=$(dirname "$(readlink -f "$HOME/.local/bin/cursor-agent")")
		for v in "$HOME"/.local/share/cursor-agent/versions/*; do
			[ "$v" != "$current_cursor_agent_dir" ] && clean_glob "$v"
		done
	fi

	echo -ne "\033[0m"
}

clean

if [ $should_log -eq 1 ]; then
	echo
fi

#calculating the new available storage after cleaning
Storage=$(df -h "$HOME" | grep -E "$(df "$HOME" | tail -1 | awk '{print $1}')" | awk '{print($4)}')
if [ "$Storage" == "0" ];
then
	Storage="0B"
fi
sleep 1
echo -e "\033[32m -- Available Storage After Cleaning : || $Storage || --\n\033[0m"

echo -e	"\n	       report any issues to me in:"
echo -e	"		   GitHub   ~> \033[4;1;34mombhd\033[0m"
echo -e	"	   	   42 Slack ~> \033[4;1;34mobouykou\033[0m\n"

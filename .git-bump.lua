--- escape_magic_characters
---
--- To avoid strange behavior, escape any non-alphanumeric characters with a leading "%", the Lua way of escaping magic
--- characters.
---
--- @param str string The raw string
--- @param only_percent boolean Escape only percentage signs instead of all characters
--- @return string The string with magic characters escaped
local function escape_magic_characters(str, only_percent)
    local pattern
    if only_percent then
        pattern = "%%"
    else
        pattern = "[^%w]"
    end

    str = str:gsub(pattern, "%%%0")
    return str
end

--- bump_callee
---
--- Replace any occurrences of tags or branch names for this repository to the new tag. This function works on the
--- called workflow files in this repository.
---
--- @param version string Version to bump to (provided by git-bump)
--- @param content string Content to be bumped (provided by git-bump)
--- @return string Modified content (fed back to git-bump)
local function bump_callee(version, content)
    -- If version is not "standard", use "develop".
    if version:find("[^%.%d]") then
        version = "develop"
    end

    local replacements = {}
    local needle = ("\n +%s\n +ref: [^\n]+\n"):format(escape_magic_characters("repository: FloGa/rust-workflows"))
    for line in content:gmatch(needle) do
        local replacement = line:gsub("ref: [^\n]+", escape_magic_characters("ref: " .. version, true))
        line = escape_magic_characters(line)
        replacements[line] = replacement
    end

    for from, to in pairs(replacements) do
        content = content:gsub(from, to)
    end

    return content
end

--- bump_caller
---
--- Replace any occurrences of tags or branch names for this repository to the new or latest tag. This function works on
--- the provided workflow snippets that can be used in other repositories.
---
--- @param version string Version to bump to (provided by git-bump)
--- @param content string Content to be bumped (provided by git-bump)
--- @return string Modified content (fed back to git-bump)
local function bump_caller(version, content)
    -- If version is not "standard", use latest stable version.
    if version:find("[^%.%d]") then
        local process = io.popen("git describe main")
        -- Use some dummy default in case we don't have a tag yet.
        version = process:read() or "0.0.0"
        process:close()
    end

    local replacements = {}
    -- Use "*" after "@", to handle cases where we were left without a version number.
    local needle = ("\n +%s[^\n]+@[^\n]*\n"):format(escape_magic_characters("uses: FloGa/rust-workflows/"))
    for line in content:gmatch(needle) do
        local replacement = line:gsub("@[^\n]*", escape_magic_characters("@" .. version, true))
        line = escape_magic_characters(line)
        replacements[line] = replacement
    end

    for from, to in pairs(replacements) do
        content = content:gsub(from, to)
    end

    return content
end

local bump_mapping = {
    ["README.md"] = bump_caller,
}

do
    local process = io.popen("find .github/workflows -type f")
    for file in process:lines() do
        bump_mapping[file] = bump_callee
    end
    process:close()
end

return bump_mapping

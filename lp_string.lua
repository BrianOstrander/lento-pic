local lp_string = {}

---Checks if a string contains the target string
---@param text string: Target string.
---@return boolean: Returns true if this string contains the target string
function lp_string.contains(value, text)
    return value:find(text, 1, true) ~= nil
end

---Checks if a string starts with the target string
---@param text string: Target string.
---@return boolean: Returns true if this string starts with target string
function lp_string.starts_with(value, text)
    return value:sub(1, #text) == text
end

---Checks if a string ends with the target string
---@param text string: Target string.
---@return boolean: Returns true if this string ends with target string
function lp_string.ends_with(value, text)
    return text == "" or value:sub(-#text) == text
end

---Split string by the provided separator, or by whitespace by default
---@param separator string: String to split by, defaults to a single space
function lp_string.split(value, separator)
    separator = separator or " "
    local result = {}
    
    for field, s in string.gmatch(value, "([^" .. separator .. "]*)(" .. separator .. "?)") do
        table.insert(result, field)
        if s == "" then
            return result
        end
    end
    
    return { value }
end

---Replaces each instance of the target string with the specified replacement string.
---@param text string: Target string.
---@param new_text string: Replacement string.
---@return string: Result of the replacement operation.
function lp_string.replace(value, text, new_text)
    local result = value
    local search_start_index = 1

    while true do
        local start_index, end_index = result:find(text, search_start_index, true)
        
        if not start_index then
            break
        end

        local remainder = result:sub(end_index + 1)
        result = result:sub(1, (start_index - 1)) .. new_text .. remainder

        search_start_index = -1 * remainder:len()
    end

    return result
end


return lp_string
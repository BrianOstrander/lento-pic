local lp_string = dofile("./lp_string.lua")

local lp_export = {}
lp_export.directory_separator = package.config:sub(1,1)

function lp_export.aftercommand(event)
    if event.name == "SaveFileAs" or event.name == "SaveFile" then
        lp_export.export()
    end
end

function lp_export.export()
    local new_filename = lp_export.get_export_filename()

    local data = lp_export.serialize_image()

    lp_export.save(
        new_filename,
        "haha test"
    )
end

function lp_export.save(
    path,
    data
)
    local file, e = io.open(
        path,
        "w"
    )

    if file then
        file:write(data)
        file:close()
    else
        print("error: ", e)
    end
end

function lp_export.serialize_image()
    
end

function lp_export.get_export_filename()
    local new_filename = lp_string.replace(
        app.editor.sprite.filename,
        ".aseprite",
        ".txt"
    )

    -- print("High score: "..tostring(score))
    -- local file,err = io.open("high_score.txt",'w')
    -- if file then
    --     file:write(tostring(score))
    --     file:close()
    -- else
    --     print("error:", err) -- not so hard?
    -- end

    return new_filename

    -- local split_paths = oo_string.split(app.editor.sprite.filename, lp_export.directory_separator)
    -- local new_filename = ""

    -- for _, v in ipairs(split_paths) do
    --     if v == oo_unity_sheeter.directory_root then
    --         break
    --     end

    --     new_filename = new_filename..v..oo_unity_sheeter.directory_separator
    -- end

    -- new_filename = new_filename..(split_paths[#split_paths])

    -- new_filename = oo_string.replace(new_filename, ".aseprite", ".png")

    -- return new_filename
end

return lp_export
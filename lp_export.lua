local lp_string = dofile("./lp_string.lua")

local lp_export = {}
lp_export.directory_separator = package.config:sub(1,1)

function lp_export.aftercommand(event)
    if event.name == "SaveFileAs" or event.name == "SaveFile" then
        lp_export.export()
    end
end

function lp_export.export()

    local image = Image(app.editor.sprite)

    local cpp_filename = lp_export.get_cpp_filename()
    local png_filename = lp_export.get_png_filename()

    local cpp_data = lp_export.get_cpp_data(
        image
    )

    image:saveAs(png_filename)

    lp_export.save(
        cpp_filename,
        cpp_data
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

function lp_export.get_name()
    local result = app.editor.sprite.filename
    local begin_index = string.len(result)
    local end_index

    while 1 < begin_index do
        local character = string.sub(result, begin_index, begin_index)

        if charcter == "/" or character == "\\" then
            begin_index = begin_index + 1
            break
        end

        if not end_index then
            if character == "." then
                end_index = begin_index - 1
            end
        end

        begin_index = begin_index - 1
    end

    return string.sub(
        result,
        begin_index,
        end_index
    )
end

function lp_export.get_cpp_filename()
    return lp_string.replace(
        app.editor.sprite.filename,
        ".aseprite",
        ".txt"
    )
end

function lp_export.get_png_filename()
    return lp_string.replace(
        app.editor.sprite.filename,
        ".aseprite",
        ".png"
    )
end

function lp_export.get_cpp_data(
    image
)
    local name = lp_export.get_name()
    local result = "// '"..name.."', "
    result = result..tostring(image.width).."x"..tostring(image.height).."px\n"
    result = result.."const unsigned char img_"..name.." [] PROGEM = {"

    local bytes = lp_export.get_cpp_data_bytes(image)

    local column_count = 16

    for byte_index, byte in ipairs(bytes) do

        if 1 < byte_index then
            result = result..", "
        end

        if column_count < 16 then
            column_count = column_count + 1
        else
            column_count = 1
            result = result.."\n\t"
        end

        result = result..string.format("0x%02x", byte)
    end

    result = result.."\n};"

    return result
end

function lp_export.get_cpp_data_bytes(
    image
)
    local grayscale = {}

    for y = 0, (image.height - 1) do
        for x = 0, (image.width - 1) do
            table.insert(
                grayscale,
                lp_export.get_cpp_data_pixel_byte(
                    image,
                    image:getPixel(x, y)
                )
            )
        end
    end

    local bitscale = {}
    local bit_count = 0
    local current_bit = 0

    for i = 1, #grayscale do
        if bit_count == 8 then
            table.insert(
                bitscale,
                current_bit
            )
            bit_count = 0
            current_bit = 0
        end 

        bit_count = bit_count + 1
        current_bit = (current_bit << 1) | grayscale[i]
    end

    if 0 < bit_count then
        table.insert(
            bitscale,
            current_bit
        )
    end

    return bitscale
end

function lp_export.get_cpp_data_pixel_byte(
    image,
    pixel
)
    local alpha = pixel >> 8

    if alpha <= 0x7f then
        return 0
    end

    local grayscale = pixel & 0xff

    if grayscale < 0x7f then
        return 1
    end

    return 0
end

return lp_export
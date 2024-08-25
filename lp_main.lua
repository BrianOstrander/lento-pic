lp_main = {} or lp_main
-- lp_main.extension_root = app.fs.filePath("./")

function lp_main.aftercommand(event)
    if event.name == "Refresh" then
        lp_main.refresh()
    end
end

function lp_main.refresh()
    if lp_main.export then
        --We have initialized before
        app.events:off(
            lp_main.export.aftercommand
        )
    else
        --We have not initialized before
        app.events:on(
            "aftercommand",
            lp_main.aftercommand
        )
    end

    local lp_export_path = app.fs.joinPath(
        app.fs.userConfigPath,
        "extensions",
        "lento-pic",
        "lp_export.lua"
    )
    
    lp_main.export = dofile(lp_export_path)

    app.events:on(
        "aftercommand",
        lp_main.export.aftercommand
    )
end

function init(plugin)
    lp_main.refresh()
end

function exit(plugin)
    app.events:off(
        lp_main.aftercommand
    )
    app.events:off(
        lp_main.export.aftercommand
    )
end
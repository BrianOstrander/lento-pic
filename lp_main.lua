lp_export = dofile("./lp_export.lua")

function init(plugin)
    app.events:on(
        "aftercommand",
        lp_export.aftercommand
    )
end

function exit(plugin)
    app.events:off(
        "aftercommand",
        lp_export.aftercommand
    )
end
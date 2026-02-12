_CMD_TEMPLATE = "$(execpath {}) $(execpath {{template}}) {} > $@"

_REPLACE_TEMPLATE = "-e 's|{}|{}|g' \\"

_INLINE_TEMPLATE = "-e '/{}/r $(execpath {})' \\"

_DELETE_TEMPLATE = "-e '/{}/d' \\"

_DELETE_BETWEEN_TEMPLATE = "-e '/{}/,/{}/d' \\"

def sed_command(
        *,
        sed,
        template,
        automake_vars,
        inline_vars,
        delete_vars,
        direct_vars,
        delete_between,
        use_direct_vars = False,
        is_windows = False):
    """Generate a sed command for producing generated bison source files.

    Args:
        sed (label): The label of a sed executable
        template (label): The label of the template
        automake_vars (dict): Mappings of key value automake pairs.
        inline_vars (dict): Mappings of keys to source files to inline.
        delete_vars (list): Deletion keys for removing lines.
        direct_vars (dict): Mappings of template keys to variables.
        use_direct_vars (bool, optional): Whether or not to use `direct_vars` at all.
        is_windows (bool, optional): Whether or not to generate a bat command.

    Returns:
        str: The sed command
    """
    sed_args = []
    for key, val in automake_vars.items():
        sed_args.append(_REPLACE_TEMPLATE.format(key, val))

    for key, val in inline_vars.items():
        sed_args.append(_INLINE_TEMPLATE.format(key, val))

    # print(use_direct_vars)

    if use_direct_vars:
        for key, val in direct_vars.items():
            print(key)
            print(val)
            sed_args.append(_REPLACE_TEMPLATE.format(key, val))


    for key in delete_vars:
        print(_DELETE_TEMPLATE.format(key))
        sed_args.append(_DELETE_TEMPLATE.format(key))
    
    # print(len(sed_args))
    # print(delete_between)
    # for [a, b] in delete_between:
    #     print("foo")
    #     sed_args.append(_DELETE_BETWEEN_TEMPLATE.format(a, b))

    # print(len(sed_args))
    # print(sed_args)


    command = _CMD_TEMPLATE.format(
        sed,
        "\n".join(sed_args).strip("\\\n"),
    ).replace("{template}", template)

    # print("*")
    print(command)
    # for arg in sed_args:
    #     print(arg)

    if is_windows:
        return command.replace("\\\n", "^\n\r")

    return command

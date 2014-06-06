query_params = ->
    search = window.location.search
    if not search
        return {}

    params = {}
    decoded_search = decodeURI(search)[1..]
    key_value_pairs = decoded_search.split("&")
    for key_value_pair in key_value_pairs
        [key, value] = key_value_pair.split("=")
        params[key] = value

    return params

# EXPORT =======================================================================
define({query_params})

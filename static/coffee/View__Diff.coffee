# TEMPLATES ====================================================================
{div, text, renderable} = window.teacup

diff_fn_line = (content, line_num, m_cls="") ->
    div ".diff-fn-line#{m_cls}", ->
        div ".diff-fn-line__line-num", ->
            text line_num
        div ".diff-fn-line__content", ->
            text content

diff_fn_template = renderable (title, lhs, rhs) ->
    div ".diff-fn.standard-view", ->
        div ".diff-fn__title.standard-view__subtitle", ->
            text title
        div ".diff-fn__diff-text", ->
            div ".diff-fn__lhs", ->
                for line in lhs
                    diff_fn_line(line.content, line.line_num, line.m_cls)
            div ".diff-fn__rhs", ->
                for line in rhs
                    diff_fn_line(line.content, line.line_num, line.m_cls)

diff_file_template = renderable (comparison) ->
    div ".diff-file.standard-view", ->
        div ".diff-file__comparison.standard-view__title", ->
            text comparison
        div ".diff-file__fn-container"

diff_compiler_template = renderable ->
    div ".diff", ->
        div ".diff__container"

diff_viewer_template = renderable ->
    div ".diff-viewer"

# VIEW =========================================================================
class DiffFn
    constructor: ->
        @_lines = []
        @_fn_title = ""
        @_lhs_current_line_num = 0
        @_rhs_current_line_num = 0
        @_lhs_lines = []
        @_rhs_lines = []
        return

    add_line: (line) ->
        @_lines.push(line)
        return

    finish: ->
        lhs_buffer = []
        rhs_buffer = []

        for line in @_lines
            switch line[0]
                when "@"
                    @comprehend_title(line)
                when "-"
                    lhs_buffer.push(@make_line(line, @_lhs_current_line_num, ".m-lhs"))
                    @_lhs_current_line_num++
                when "+"
                    rhs_buffer.push(@make_line(line, @_rhs_current_line_num, ".m-rhs"))
                    @_rhs_current_line_num++
                else
                    lhs_buffer_length = lhs_buffer.length
                    rhs_buffer_length = rhs_buffer.length

                    if lhs_buffer_length or rhs_buffer_length
                        if lhs_buffer_length > rhs_buffer_length
                            for num in [rhs_buffer_length...lhs_buffer_length]
                                rhs_buffer.push(@make_line(""))
                        else
                            for num in [lhs_buffer_length...rhs_buffer_length]
                                lhs_buffer.push(@make_line(""))

                        @_lhs_lines = @_lhs_lines.concat(lhs_buffer)
                        @_rhs_lines = @_rhs_lines.concat(rhs_buffer)

                    @_lhs_lines.push(@make_line(line, @_lhs_current_line_num))
                    @_rhs_lines.push(@make_line(line, @_rhs_current_line_num))
                    @_lhs_current_line_num++
                    @_rhs_current_line_num++
                    lhs_buffer = []
                    rhs_buffer = []

        if lhs_buffer.length
            @_lhs_lines = @_lhs_lines.concat(lhs_buffer)

        if rhs_buffer.length
            @_rhs_lines = @_rhs_lines.concat(rhs_buffer)
        return

    comprehend_title: (title_text) ->
        title_components = title_text.split("@@")
        line_nums = title_components[1]
        line_num_components = line_nums.split(" ")
        lhs_line_nums = line_num_components[1]
        rhs_line_nums = line_num_components[2]

        @_lhs_current_line_num = parse_int(lhs_line_nums.split(",")[0][1..])
        @_rhs_current_line_num = parse_int(rhs_line_nums.split(",")[0][1..])
        @_fn_title = title_components[2] or "in file:"

        return

    make_line: (line_text, line_num="", m_cls="") ->
        return {content: line_text[1..], line_num, m_cls}

    content: ->
        return $(diff_fn_template(@_fn_title, @_lhs_lines, @_rhs_lines))

class DiffFile
    constructor: ->
        @_lines = []
        @_comparison = ""
        @_index = ""
        @_lhs_file = ""
        @_rhs_file = ""
        @_diff_fns = []
        return

    add_line: (line) ->
        @_lines.push(line)
        return

    finish: ->
        current_diff_fn = null

        for line, index in @_lines
            switch index
                when 0 then @_comparison = line
                when 1 then @_index = line
                when 2 then @_lhs_file = line
                when 3 then @_rhs_file = line
                else
                    if line[0..1] == "@@"
                        @complete_diff_fn(current_diff_fn)
                        current_diff_fn = new DiffFn()

                    current_diff_fn?.add_line(line)

        @complete_diff_fn(current_diff_fn)
        return

    complete_diff_fn: (diff_fn) ->
        return if not diff_fn
        @_diff_fns.push(diff_fn)
        diff_fn.finish()
        return

    content: ->
        $el = $(diff_file_template(@_comparison))
        $container = $el.find(".diff-file__fn-container")

        for fn in @_diff_fns
            $container.append(fn.content())

        return $el

class DiffCompiler
    constructor: (diff_text) ->
        @_diff_files = []
        @organize_diff(diff_text)
        return

    organize_diff: (diff_text) ->
        diff_lines_array = diff_text.split("\n")

        current_diff = null
        for line in diff_lines_array
            if line[0..3] == "diff"
                @complete_diff(current_diff)
                current_diff = new DiffFile()

            current_diff?.add_line(line)

        @complete_diff(current_diff)
        console.log @_diff_files
        return

    complete_diff: (diff_file) ->
        return if not diff_file
        @_diff_files.push(diff_file)
        diff_file.finish()
        return

    content: ->
        $el = $(diff_compiler_template())
        $container = $el.find(".diff__container")
        for file in @_diff_files
            $container.append(file.content())

        return $el

define ["view"], ({View}) ->
    class View__Diff extends View
        @url = "/#diff"

        constructor: (diff) ->
            super
            @diff = null
            @organize_diff(diff)
            return

        organize_diff: (diff) ->
            @diff = new DiffCompiler(diff)
            return

        render: ->
            @$el = $(diff_viewer_template())
            @$el.append(@diff.content())
            return

    return View__Diff
" in order to run this program, use the command below:
" vim --cmd ":source ./day6.vim" --cmd "quit"

function! Main(num, distance)
    let i = 1
    let counter = 0
    while (i <= a:num)
        let time = i * (a:num - i)
        if time > a:distance
            let counter += 1
        endif
        let i += 1
    endwhile
    return counter
endfunction

function! PartOne(lines)
    let first_line = split(substitute(a:lines[0], '\s\+', ' ', 'g'), ' ')
    let second_line = split(substitute(a:lines[1], '\s\+', ' ', 'g'), ' ')
    let sum = 1

    let i = 1
    while (i < len(first_line))
        let sum *= Main(first_line[i], second_line[i])
        let i += 1
    endwhile
    call writefile([string(sum)], "/dev/stdout", "s")
endfunction

function! PartTwo(lines)
    let sum = 1

    let first_line = matchstr(substitute(a:lines[0], '\s\+', '', 'g'), '\d\+')
    let second_line = matchstr(substitute(a:lines[1], '\s\+', '', 'g'), '\d\+')

    let sum *= Main(first_line, second_line)
    call writefile([string(sum)], "/dev/stdout", "s")
endfunction

let lines = readfile('./input.txt', 1)
call PartOne(lines)
call PartTwo(lines)

local file = io.open("input.txt", "r")

local lines = {}
if file ~= nil then
	local value = file:read("*line")
	while value do
		table.insert(lines, value)
		value = file:read("*line")
	end
	file:close()
end

local function mapping(seeds, map)
	if #map == 0 then return seeds end
	local changed = {}
	for i = 1, #seeds do
		changed[i] = false
	end

	for line = 1, #map do
		local col = 1
		for number in map[line]:gmatch "%d*" do
			if col == 1 then DESTINATION_START = tonumber(number) end
			if col == 2 then SOURCE_START = tonumber(number) end
			if col == 3 then RANGE = tonumber(number) end
			col = col + 1
		end

		for i = 1, #seeds do
			if not changed[i] then
				if (SOURCE_START <= tonumber(seeds[i]) and tonumber(seeds[i]) < (SOURCE_START + RANGE)) then
					changed[i] = true
					if (DESTINATION_START > SOURCE_START) then
						seeds[i] = tonumber(seeds[i]) + DESTINATION_START - SOURCE_START
					else
						if (DESTINATION_START < SOURCE_START) then
							seeds[i] = tonumber(seeds[i]) - (SOURCE_START - DESTINATION_START)
						end
					end
				end
			end
		end
		line = line + 1
	end
	return seeds
end

local function mappingRanges(seed_ranges, map)
	local newPairs = {}

	for _, pair in ipairs(seed_ranges) do
		local seed = tonumber(pair[1])
		local end_seed = tonumber(pair[2])

		for index = 1, #map do
			local DESTINATION_START = map[index][1]
			local SOURCE_START = map[index][2]
			local RANGE = map[index][3]
			if seed ~= nil and end_seed ~= nil then
				local overlap_start = math.max(seed, SOURCE_START)
				local overlap_end = math.min(end_seed, SOURCE_START + RANGE)

				if overlap_start < overlap_end then
					table.insert(newPairs,
						{ overlap_start - SOURCE_START + DESTINATION_START, overlap_end - SOURCE_START +
						DESTINATION_START })

					if overlap_start > seed then
						table.insert(seed_ranges, { seed, overlap_start })
					end

					if end_seed > overlap_end then
						table.insert(seed_ranges, { overlap_end, end_seed })
					end

					break
				end
			end
		end

		if #map == 0 then
			table.insert(newPairs, { seed, end_seed })
		end
	end

	local smallest = nil
	for _, pair in ipairs(newPairs) do
		local DESTINATION_START = pair[1]
		if not smallest or DESTINATION_START < smallest then
			smallest = DESTINATION_START
		end
	end

	return newPairs, smallest
end

function PART1()
	local seeds = {}
	for i = 1, #lines do
		if (lines[i]:match("seeds:.*")) then
			for seed in string.gmatch(lines[i], "([^" .. "%s" .. "]+)") do
				table.insert(seeds, seed)
			end
			table.remove(seeds, 1)
		end
	end

	local map = {}
	local line = 1
	while line < #lines + 1 do
		local nextLine = lines[line + 1]
		if nextLine == nil then
			table.insert(map, lines[line])
			seeds = mapping(seeds, map)
			break
		end

		if nextLine:match("map") then
			seeds = mapping(seeds, map)
			map = {}
		end

		if not nextLine:match(".*map.*") and lines[line]:match("[0-9]*") and not lines[line]:match("seeds") and nextLine ~= "" then
			table.insert(map, lines[line + 1])
		end
		line = line + 1
	end


	local smallest = seeds[1]
	for i = 1, #seeds do
		if tonumber(seeds[i + 1]) ~= nil then
			smallest = math.min(smallest, seeds[i + 1])
		end
	end
	print(smallest)
end

function PART2()
	local arr = {}
	for i = 1, #lines do
		if (lines[i]:match("seeds:.*")) then
			for number in lines[i]:gmatch "%d+" do
				table.insert(arr, number)
			end
		end
	end

	local seed_ranges = {}
	for i = 1, #arr, 2 do
		local max = arr[i] + arr[i + 1]
		table.insert(seed_ranges, { arr[i], math.floor(max) })
	end

	local map = {}
	local line = 1
	while line < #lines + 1 do
		local nextLine = lines[line + 1]
		if nextLine == nil then
			seed_ranges, min = mappingRanges(seed_ranges, map)
			print(min)
			break
		end

		if nextLine:match("map") then
			seed_ranges = mappingRanges(seed_ranges, map)
			map = {}
		end

		if not nextLine:match(".*map.*") and lines[line]:match("[0-9]*") and not lines[line]:match("seeds") and nextLine ~= "" then
			local values = {}
			for value in lines[line + 1]:gmatch("%d+") do
				table.insert(values, tonumber(value))
			end
			table.insert(map, values)
		end
		line = line + 1
	end
end

PART1()
PART2()

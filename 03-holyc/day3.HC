// The code for Part 2 was written with God's help, I will not optimize it since making it work was enough for me.
Cd(__DIR__);

#define INPUT_FILE "input.TXT"

U64 ParseChar(U8 ch)
{
	if (ch=='0' || ch=='1' || ch=='2' || ch=='3' ||
			ch=='4' || ch=='5' || ch=='6' || ch=='7' ||
			ch=='8' || ch=='9') return 0;
	if (ch=='\n') return 1;
	if (ch=='.') return 2;
	return 3;
}

I64 Pwr(I64 p)
{
	I64 i;
	I64 res = 1;
	for (i = 0; i < p; i++)
	{
		res *= 10;
	}
	return res;
}

Bool specialCharOnTop(U8 *ptr, I64 length)
{
	if (ParseChar(*(ptr - length - 2)) == 3 || ParseChar(*(ptr - length - 1)) == 3 ||
			ParseChar(*(ptr - length)) == 3) return TRUE;
	return FALSE;
}

Bool specialCharOnBtm(U8 *ptr, I64 length)
{
	if (ParseChar(*(ptr + length)) == 3 || ParseChar(*(ptr + length + 1)) == 3 ||
			ParseChar(*(ptr + length + 2)) == 3) return TRUE;
	return FALSE;
}

Bool UCheck(U8 *ptr, I64 length)
{
	if (ParseChar(*(ptr + 1)) == 0 || ParseChar(*(ptr + length + 2)) == 0 ||
			ParseChar(*(ptr + length + 1)) == 0 || ParseChar(*(ptr + length)) == 0 ||
			ParseChar(*(ptr - 1)) == 0) return TRUE;
	return FALSE;
}

Bool PCheck(U8 *ptr, I64 length)
{
	if (ParseChar(*(ptr - 1)) == 0 || ParseChar(*(ptr - length - 2)) == 0 ||
			ParseChar(*(ptr - length - 1)) == 0 || ParseChar(*(ptr - length)) == 0 ||
			ParseChar(*(ptr + 1)) == 0) return TRUE;
	return FALSE;
}

I64 yoinkNumber(U8 *ptr)
{
	U8 *ptrCpy;
	ptrCpy = ptr;
	I64 i;
	I64 charType;
	I64 num = 0;

	i = 0;
	do {
		charType = ParseChar(*ptrCpy);
		++i;
		--ptrCpy;
	} while (charType == 0);
	ptrCpy += 2;

	i = 0;
	do {
		charType = ParseChar(*ptrCpy);
		++i;
		++ptrCpy;
	} while (charType == 0);
	ptrCpy -= 2;

	i = 0;
	while (ParseChar(*(ptrCpy - i)) == 0)
	{
		num += Pwr(i) * (*(ptrCpy - i) - '0');
		++i;
	}
	return num;
}

U0 Part1()
{
	I64 len;
	U8 *buffer = FileRead(INPUT_FILE, 1, &len);
	U8 *ptr;
	U64 charType;
	I64 line = 0;
	I64 num;
	I64 sum = 0;
	Bool adjacent;
	I64 length = 0;

	for (ptr = buffer; *ptr; ++ptr)
	{
		charType = ParseChar(*ptr);
		if (charType != 1) 
		{
			++length;
		}
		else
		{
			break;
		}
	}

	for (ptr = buffer; *ptr; ++ptr)
	{
		adjacent = FALSE;
		charType = ParseChar(*ptr);
		if (charType == 1)
		{
			++line;
		}
		else
		{
			if (ParseChar(*(ptr + 1)) != 0)
			{
				I64 i = 0;
				num = 0;
				while (ParseChar(*(ptr - i)) == 0)
				{
					num += Pwr(i) * (*(ptr - i) - '0');
					if (line != (length - 1))
					{
						if (specialCharOnBtm(ptr - i, length)) adjacent = TRUE;
					}
					if (line != 0 )
					{
						if (specialCharOnTop(ptr - i, length)) adjacent = TRUE;
					}
					if (ParseChar(*(ptr - i - 1)) == 3 ||
							ParseChar(*(ptr - i + 1)) == 3) adjacent = TRUE;
					++i;
				}
				if (adjacent) 
				{
					sum += num; 
				}
			}
		}
	}
	"Part 1: %d\n", sum;
}

U0 Part2()
{
	I64 len;
	I64 length = 0;
	U8 *buffer = FileRead(INPUT_FILE, 1, &len);
	U8 *ptr;
	I64 num;
	I64 sum = 0;

	for (ptr = buffer; *ptr; ++ptr)
	{
		if (*ptr != '\n') 
		{
			++length;
		} else
		{
			break;
		}
	}

	for (ptr = buffer; *ptr; ++ptr)
	{
		num = 1;
		if (*ptr == '*')
		{
			if (ParseChar(*(ptr - length - 2)) == 0)
			{
				if (UCheck(ptr, length))
				{
					num *= yoinkNumber(ptr - length - 2);
				} else if (ParseChar(*(ptr - length - 1)) != 0 && 
						ParseChar(*(ptr - length)) == 0)
				{
					num *= yoinkNumber(ptr - length - 2);
				}
			}

			if (ParseChar(*(ptr - length - 1)) == 0)
			{
				if (UCheck(ptr, length))
				{
					if (ParseChar(*(ptr - length - 2)) != 0)
					{
						num *= yoinkNumber(ptr - length - 1);
					}
				}
			}

			if (ParseChar(*(ptr - length)) == 0)
			{
				if (ParseChar(*(ptr - length - 1))!= 0 && ParseChar(*(ptr - length - 2))== 0)
				{
					num *= yoinkNumber(ptr - length);
				}
				if(ParseChar(*(ptr - length - 1)) != 0 &&UCheck(ptr, length))
				{
					num *= yoinkNumber(ptr - length);
				}
			}

			if (ParseChar(*(ptr + 1)) == 0)
			{
				if (ParseChar(*(ptr - length - 2)) == 0 ||ParseChar(*(ptr - length - 1)) == 0 ||
						ParseChar(*(ptr - length)) == 0 || ParseChar(*(ptr + length + 2)) == 0 ||
						ParseChar(*(ptr + length + 1)) == 0 ||ParseChar(*(ptr + length)) == 0 ||
						ParseChar(*(ptr - 1)) == 0) 
				{
					num *= yoinkNumber(ptr + 1);
				}
			}

			if (ParseChar(*(ptr + length + 2)) == 0)
			{
				if (PCheck(ptr, length)) 
				{
					num *= yoinkNumber(ptr + length + 2);
				} else if (ParseChar(*(ptr + length + 1)) != 0 &&ParseChar(*(ptr + length)) == 0)
				{
					num *= yoinkNumber(ptr+length + 2);
				}
			}

			if (ParseChar(*(ptr + length + 1)) == 0)
			{
				if (PCheck(ptr, length))
				{
					if (ParseChar(*(ptr + length)) == 0)
					{
						if (ParseChar(*(ptr + length +2)) != 0)
						{
							num *= yoinkNumber(ptr + length +1);
						}
					}
				}
			}

			if (ParseChar(*(ptr + length)) == 0)
			{
				if (PCheck(ptr, length))
				{
					if (ParseChar(*(ptr+ length +1)) != 0)
					{
						num *= yoinkNumber(ptr+length);
					}
				}
				if (ParseChar(*(ptr +length +1)) != 0 && ParseChar(*(ptr + length +2)) == 0)
				{
					num *= yoinkNumber(ptr+length);
				}
			}

			if (ParseChar(*(ptr - 1)) == 0)
			{
				if (ParseChar(*(ptr - length - 2)) == 0 ||ParseChar(*(ptr - length + 1)) == 0 ||
						ParseChar(*(ptr - length)) == 0 || ParseChar(*(ptr + length + 2)) == 0 ||
						ParseChar(*(ptr + length + 1)) == 0 ||ParseChar(*(ptr + 1)) == 0)
				{
					num *= yoinkNumber(ptr - 1);
				}
			}
		}
		if (num != 1)
		{
			sum += num;
		}
	}
	"Part 2: %d\n", sum;
}

Part1;
Part2;

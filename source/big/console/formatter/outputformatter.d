/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.formatter.outputformatter;

import std.string;
import std.format;

import big.console.formatter;
import big.console.exception;

class OutputFormatter : OutputFormatterInterface
{
public:
    this(bool decorated = false, OutputFormatterStyleInterface[string] styles = null)
    {
        _decorated = decorated;
        setStyle("error", new OutputFormatterStyle("white", "red"));
        setStyle("info", new OutputFormatterStyle("green"));
        setStyle("comment", new OutputFormatterStyle("yellow"));
        setStyle("question", new OutputFormatterStyle("black", "cyan"));
        foreach (name, style; styles)
        {
            setStyle(name, style);
        }
        _styleStack = new OutputFormatterStyleStack();

    }

    static string escape(string text)
    {
        //    	text = replaceAll(text, regex(r"/([^\\\\]?)</"), "");
        //            $text = preg_replace('/([^\\\\]?)</', '$1\\<', $text);
        //            if ('\\' === substr($text, -1)) {
        //                $len = strlen($text);
        //                $text = rtrim($text, '\\');
        //                $text .= str_repeat('<<', $len - strlen($text));
        //            }
        return text;
    }

    void setDecorated(bool decorated)
    {
        _decorated = decorated;
    }

    bool isDecorated()
    {
        return _decorated;
    }

    void setStyle(string name, OutputFormatterStyleInterface style)
    {
        _styles[name.toLower] = style;
    }

    bool hasStyle(string name)
    {
        return !((name.toLower in _styles) is null);
    }

    OutputFormatterStyleInterface getStyle(string name)
    {
        if (!hasStyle(name))
        {
            throw new InvalidArgumentException(std.format.format("Undefined style: %s",
                name));
        }
        return _styles[name.toLower];
    }

    string format(string message)
    {
        uint offset = 0;
        string output = "";
        string tagRegex = "[a-z][a-z0-9,_=;-]*+";
        //            preg_match_all("#<(($tagRegex) | /($tagRegex)?)>#ix", $message, $matches, PREG_OFFSET_CAPTURE);
        //            foreach ($matches[0] as $i => $match) {
        //                $pos = $match[1];
        //                $text = $match[0];
        //                if (0 != $pos && '\\' == $message[$pos - 1]) {
        //                    continue;
        //                }
        //                // add the text up to the next tag
        //                $output .= $this->applyCurrentStyle(substr($message, $offset, $pos - $offset));
        //                $offset = $pos + strlen($text);
        //                // opening tag?
        //                if ($open = '/' != $text[1]) {
        //                    $tag = $matches[1][$i][0];
        //                } else {
        //                    $tag = isset($matches[3][$i][0]) ? $matches[3][$i][0] : '';
        //                }
        //                if (!$open && !$tag) {
        //                    // </>
        //                    $this->styleStack->pop();
        //                } elseif (false === $style = $this->createStyleFromString(strtolower($tag))) {
        //                    $output .= $this->applyCurrentStyle($text);
        //                } elseif ($open) {
        //                    $this->styleStack->push($style);
        //                } else {
        //                    $this->styleStack->pop($style);
        //                }
        //            }
        //                    output ~= applyCurrentStyle(substr($message, $offset));
        if (output.indexOf("<<") > 0)
        {
            //                        return strtr($output, array('\\<' => '<', '<<' => '\\'));
        }
        return output.replace("\\<", "<");
    }

private:
    bool _decorated;
    OutputFormatterStyleInterface[string] _styles;
    OutputFormatterStyleStack _styleStack;

    //    /**
    //     * @return OutputFormatterStyleStack
    //     */
    //    public function getStyleStack()
    //    {
    //        return $this->styleStack;
    //    }
    //    /**
    //     * Tries to create new style instance from string.
    //     *
    //     * @param string $string
    //     *
    //     * @return OutputFormatterStyle|bool false if string is not format string
    //     */
    //    private function createStyleFromString($string)
    //    {
    //        if (isset($this->styles[$string])) {
    //            return $this->styles[$string];
    //        }
    //        if (!preg_match_all('/([^=]+)=([^;]+)(;|$)/', $string, $matches, PREG_SET_ORDER)) {
    //            return false;
    //        }
    //        $style = new OutputFormatterStyle();
    //        foreach ($matches as $match) {
    //            array_shift($match);
    //            if ('fg' == $match[0]) {
    //                $style->setForeground($match[1]);
    //            } elseif ('bg' == $match[0]) {
    //                $style->setBackground($match[1]);
    //            } elseif ('options' === $match[0]) {
    //                preg_match_all('([^,;]+)', $match[1], $options);
    //                $options = array_shift($options);
    //                foreach ($options as $option) {
    //                    try {
    //                        $style->setOption($option);
    //                    } catch (\InvalidArgumentException $e) {
    //                        @trigger_error(sprintf('Unknown style options are deprecated since version 3.2 and will be removed in 4.0. Exception "%s".', $e->getMessage()), E_USER_DEPRECATED);
    //                        return false;
    //                    }
    //                }
    //            } else {
    //                return false;
    //            }
    //        }
    //        return $style;
    //    }
    //    /**
    //     * Applies current style from stack to text, if must be applied.
    //     *
    //     * @param string $text Input text
    //     *
    //     * @return string Styled text
    //     */
    //    private function applyCurrentStyle($text)
    //    {
    //        return $this->isDecorated() && strlen($text) > 0 ? $this->styleStack->getCurrent()->apply($text) : $text;
    //    }
}

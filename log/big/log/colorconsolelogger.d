/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.log.colorconsolelogger;

import std.datetime: DateTime;
import std.experimental.logger: Logger, LogLevel;
import std.format: formattedWrite;
import std.stdio: File, stdout;
import std.string: format;

version(Windows)
{
  /// Color for Windows console
  enum Color : ushort
  {
    black        = 0, /// The black color
    blue         = 1, /// The blue color
    green        = 2, /// The green color
    cyan         = 3, /// The cyan color
    red          = 4, /// The red color
    magenta      = 5, /// The magenta color
    yellow       = 6, /// The yellow color
    lightGray    = 7, /// The light gray color
    
    gray         = 8,  /// The gray color
    lightBlue    = 9,  /// The light blue color
    lightGreen   = 10, /// The light green color
    lightCyan    = 11, /// The light cyan color
    lightRed     = 12, /// The light red color
    lightMagenta = 13, /// The light magenta color
    lightYellow  = 14, /// The light yellow color
    white        = 15, /// The white color
    
    bright       = 8,  /// Bright flag. Use with dark colors to make them light equivalents.
    initial = 256 /// Default color.
  }
}
else version(Posix)
{
  /// Color for Posix console
  enum Color : ushort
  {
    black        = 30, /// The black color
    red          = 31, /// The red color
    green        = 32, /// The green color
    yellow       = 33, /// The yellow color
    blue         = 34, /// The blue color
    magenta      = 35, /// The magenta color
    cyan         = 36, /// The cyan color
    lightGray    = 37, /// The light gray color
    gray         = 94,  /// The gray color
    lightRed     = 95,  /// The light red color
    lightGreen   = 96,  /// The light green color
    lightYellow  = 97,  /// The light yellow color
    lightBlue    = 98,  /// The light red color
    lightMagenta = 99,  /// The light magenta color
    lightCyan    = 100, /// The light cyan color
    white        = 101, /// The white color
    bright       = 64,  /// Bright flag. Use with dark colors to make them light equivalents.
    initial      = 256  /// Default color
  }

  /// Text style for Posix console
  enum
  {
    UNDERLINE_ENABLE  = 4,  /// Enable underline text to console
    UNDERLINE_DISABLE = 24, /// Disable underline text to console
    STRIKE_ENABLE     = 9,  /// Enable Strike text to console
    STRIKE_DISABLE    = 29, /// Disable Strike text to console
    BOLD_ENABLE       = 1,  /// Enable Bold text to console
    BOLD_DISABLE      = 21  /// Disable Bold text to console
  }
}

/// This $(D Logger) implementation writes color log messages to standart STDOUT
class ColorConsoleLogger: Logger
{
  public:
    /** A constructor for the $(D ColorConsoleLogger) Logger.
    * Params:
    *   logLevel = The $(D LogLevel) for the $(D ColorConsoleLogger). By default - LogLevel.warning
    *   outFile = The $(D File) output for write log messages
    *
    * Example:
    * -------------
    * auto logger1 = new ColorConsoleLogger();
    * auto logger2 = new ColorConsoleLogger(LogLevel.fatal);
    * -------------
    */
    this(in LogLevel logLevel = LogLevel.warning, File outFile = stdout) @safe
    {
      super(logLevel);
      _out = outFile;
    }

    /** This methods overrides the base class method and delegates the
    * $(D LogEntry) data to the actual implementation.
    */
    override void writeLogMsg(ref LogEntry payload) @trusted
    {
      {
        const auto dateTime = cast(DateTime) payload.timestamp;
        string dateTimeISO = "%04d-%02d-%02dT%02d:%02d:%02d.%03d".format( dateTime.year,
                                                                          dateTime.month,
                                                                          dateTime.day,
                                                                          dateTime.hour,
                                                                          dateTime.minute,
                                                                          dateTime.second,
                                                                          payload.timestamp.fracSecs.total!"msecs");
        auto writer = _out.lockingTextWriter();
        formattedWrite(writer, "%s ", dateTimeISO);
        
        switch(payload.logLevel)
        {
          default: 
            setTextColor(Color.initial, Color.initial, writer);
            break;
          case LogLevel.info: 
            setTextColor(Color.lightBlue, Color.lightBlue, writer);
            break;
          case LogLevel.warning: 
            setTextColor(Color.lightYellow, Color.lightYellow, writer);
            break;
          case LogLevel.error: 
            setTextColor(Color.lightRed, Color.lightRed, writer);
            break;
          case LogLevel.critical: 
            setTextColor(Color.lightMagenta, Color.lightMagenta, writer);
            break;        
        }

        writer.put("  ");
        setTextColor(Color.initial, Color.initial, writer);
        writer.put(" [");

        switch(payload.logLevel)
        {
          default: 
            setTextColor(Color.initial, Color.initial, writer);
            break;
          case LogLevel.info: 
            setTextColor(Color.lightBlue, Color.initial, writer);
            break;
          case LogLevel.warning: 
            setTextColor(Color.lightYellow, Color.initial, writer);
            break;
          case LogLevel.error: 
            setTextColor(Color.lightRed, Color.initial, writer);
            break;
          case LogLevel.critical: 
            setTextColor(Color.lightMagenta, Color.initial, writer);
            break;        
        }
        
        formattedWrite(writer, "%s", payload.logLevel);
        setTextColor(Color.initial, Color.initial, writer);
        formattedWrite(writer, "] %s\n", payload.msg);
        _out.flush();
      }
    }

  private:
    /** Set color for console
    * Params:
    *   color = The text color
    *   backgroundColor = The background color
    *   writer = LockingTextWriter for put text
    */
    void setTextColor(Color color, Color backgroundColor, File.LockingTextWriter writer)
    {
      version(Windows)
      {
        // TODO: Make Windows color version
      }
      else version(Posix)
      {
        writer.put("\033[%d;%d;%d;%d;%d;%dm".format(color &  Color.bright ? 1 : 0,
                                                    color & ~Color.bright,
                                                    (backgroundColor & ~Color.bright) + 10,
                                                    UNDERLINE_DISABLE,
                                                    STRIKE_DISABLE,
                                                    BOLD_DISABLE));
      }
    }

    /// $(D File) output for write color log messages
    File _out;
}

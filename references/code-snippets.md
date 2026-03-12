# Code Snippet Library

Reusable patterns extracted from SHINJIN/DAEHYUN projects. Copy and adapt for new projects.

---

## 1. Serial Polling (Timer + Read Thread)

Most common pattern (8+ projects). Timer sends request, background thread reads response.

```csharp
public class SerialPoller : IDisposable
{
    private SerialPort _port;
    private Thread _readThread;
    private volatile bool _running;
    private readonly StringBuilder _buffer = new(256);

    public event Action<string> DataReceived;

    public void Open(string portName, int baudRate, string sendCommand, int pollMs = 100)
    {
        _port = new SerialPort(portName, baudRate, Parity.None, 8, StopBits.One);
        _port.Open();
        _running = true;
        _readThread = new Thread(() => ReadLoop(sendCommand, pollMs)) { IsBackground = true };
        _readThread.Start();
    }

    private void ReadLoop(string cmd, int pollMs)
    {
        var sw = Stopwatch.StartNew();
        while (_running)
        {
            try
            {
                // Poll
                if (sw.ElapsedMilliseconds >= pollMs)
                {
                    _port.Write(cmd);
                    sw.Restart();
                }
                // Read
                if (_port.BytesToRead > 0)
                {
                    _buffer.Append(_port.ReadExisting());
                    int idx;
                    while ((idx = _buffer.ToString().IndexOf("\r\n")) >= 0)
                    {
                        string line = _buffer.ToString(0, idx);
                        _buffer.Remove(0, idx + 2);
                        DataReceived?.Invoke(line);
                    }
                }
                Thread.Sleep(5);
            }
            catch (Exception ex) { /* log */ }
        }
    }

    public void Dispose()
    {
        _running = false;
        _readThread?.Join(1000);
        _port?.Close();
        _port?.Dispose();
    }
}
```

---

## 2. LS PLC Cnet Communication

State machine: Read IN0 → Read IN1 → Write OUT0 → Write OUT1 (10ms cycle).

```csharp
// Key constants
const byte ENQ = 0x05, ACK = 0x06, ETX = 0x03;
// Read:  ENQ 00RSB07 %DW4000 0032 EOT
// Write: ENQ 00WSB07 %DW5000 0032 {hex_data} EOT
// Addresses: IN0=%DW4000(32w), IN1=%DW4032(32w), OUT0=%DW5000(32w), OUT1=%DW5032(32w)
// Timeout: 1000ms, auto-reopen after 3 consecutive failures
// Bit access: word_index = bit / 16, bit_offset = bit % 16
```

---

## 3. Sensor Value Reader (RI-20W Style)

Event-driven, regex parsing for value+unit.

```csharp
private static readonly Regex NumUnitRegex =
    new(@"([+-]?\d+(?:\.\d+)?(?:[eE][+-]?\d+)?)([A-Za-z%µ]*)");

// Query:  ID{id:D2}P\r\n    → Response: ID,{id},{value}{unit}\r\n
// Stream: continuous ST,NT,+01234.5\r\n (set F-40=000, F-42=0)
// Zero:   ID{id}Z\r\n

private void ParseLine(string line)
{
    var parts = line.Split(',');
    if (parts.Length >= 3)
    {
        var match = NumUnitRegex.Match(parts[2]);
        if (match.Success)
        {
            Value = double.Parse(match.Groups[1].Value);
            Unit = match.Groups[2].Value;
            ValueReceived?.Invoke(Value, Unit);
        }
    }
}
```

---

## 4. Access MDB with OleDbDataAdapter

Auto CRUD with DataTable change tracking (15+ uses).

```csharp
private static readonly string ConnStr =
    "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" +
    AppDomain.CurrentDomain.BaseDirectory + @"\DB\DataBase_Setting.accdb";

public static (DataTable table, OleDbDataAdapter adapter) Load(string sql)
{
    var adapter = new OleDbDataAdapter(sql, ConnStr)
    {
        MissingSchemaAction = MissingSchemaAction.AddWithKey
    };
    var cb = new OleDbCommandBuilder(adapter) { QuotePrefix = "[", QuoteSuffix = "]" };
    adapter.InsertCommand = cb.GetInsertCommand();
    adapter.UpdateCommand = cb.GetUpdateCommand();
    adapter.DeleteCommand = cb.GetDeleteCommand();

    var table = new DataTable();
    adapter.Fill(table);
    return (table, adapter);
}

// Save: adapter.Update(table); table.AcceptChanges();
```

---

## 5. OleDb Direct Query

Simple read pattern for non-editable data.

```csharp
public static List<T> Query<T>(string sql, Func<OleDbDataReader, T> map)
{
    var list = new List<T>();
    using var conn = new OleDbConnection(ConnStr);
    conn.Open();
    using var cmd = new OleDbCommand(sql, conn);
    using var rd = cmd.ExecuteReader();
    while (rd.Read()) list.Add(map(rd));
    return list;
}
```

---

## 6. ZedGraph Init + Draw

Static helper for graph setup with rolling data and guidelines.

```csharp
public static void InitGraph(ZedGraphControl zg, string title, string yTitle,
    double yMin, double yMax, int capacity = 3000, Color? color = null)
{
    var pane = zg.GraphPane;
    zg.IsAntiAlias = true;
    pane.Title.Text = title;
    pane.XAxis.Title.Text = "Distance (mm)";
    pane.YAxis.Title.Text = yTitle;
    pane.YAxis.Scale.Min = yMin;
    pane.YAxis.Scale.Max = yMax;

    var rolling = new RollingPointPairList(capacity);
    var curve = pane.AddCurve(title, rolling, color ?? Color.RoyalBlue, SymbolType.None);
    curve.Line.Width = 3f;
    curve.Line.IsSmooth = true;
    zg.AxisChange();
}

public static void AddPoint(ZedGraphControl zg, double x, double y)
{
    var pts = zg.GraphPane.CurveList[0].Points as IPointListEdit;
    pts.Add(x, y);
    zg.GraphPane.XAxis.Scale.Max = Math.Max(x, 1);
    zg.AxisChange();
}

// Guidelines: LineObj with Tag="GUIDE_LINE", DashStyle.Dash
```

---

## 7. INI File Read/Write

Simple section/key config (8+ projects).

```csharp
public class IniFile
{
    private readonly string _path;
    public IniFile(string path) { _path = path; }

    public string Read(string section, string key, string def = "")
    {
        if (!File.Exists(_path)) return def;
        bool inSection = false;
        foreach (var line in File.ReadLines(_path))
        {
            var t = line.Trim();
            if (t.StartsWith("[") && t.EndsWith("]"))
                inSection = t.Trim('[', ']') == section;
            else if (inSection && t.Contains('='))
            {
                var parts = t.Split(new[] { '=' }, 2);
                if (parts[0].Trim() == key) return parts[1].Trim();
            }
        }
        return def;
    }

    // Write: read all lines → find section → find key → replace or append
}
```

---

## 8. PropertyGrid Configuration

Attribute-decorated class for settings UI (10+ uses).

```csharp
public class DeviceConfig
{
    [Category("Communication")]
    [DisplayName("PLC Port")]
    [TypeConverter(typeof(ComPortConverter))]
    public string PlcPort { get; set; } = "COM1";

    public void Apply() { GlobalValues.PlcPort = PlcPort; }
    public void LoadFrom() { PlcPort = GlobalValues.PlcPort; }
}

private class ComPortConverter : StringConverter
{
    public override bool GetStandardValuesSupported(ITypeDescriptorContext c) => true;
    public override bool GetStandardValuesExclusive(ITypeDescriptorContext c) => true;
    public override StandardValuesCollection GetStandardValues(ITypeDescriptorContext c)
        => new(Enumerable.Range(1, 20).Select(i => $"COM{i}").ToArray());
}
```

---

## 9. Timer State Machine

Most used pattern (25+ times). Form timer drives sequential control.

```csharp
private int _state = 0;
private readonly System.Windows.Forms.Timer _tmr = new() { Interval = 50 };

private void TimerTick(object s, EventArgs e)
{
    try
    {
        switch (_state)
        {
            case 0: /* read sensors */ _state = 1; break;
            case 1: /* evaluate */     _state = 2; break;
            case 2: /* actuate */      _state = 0; break;
        }
    }
    catch (Exception ex) { AppendLog($"[Timer] {ex.Message}"); }
}
```

---

## 10. Thread-Safe Log Queue

BlockingCollection + background writer for high-throughput logging.

```csharp
private readonly BlockingCollection<string> _logQueue = new();
private CancellationTokenSource _logCts;

private void StartLogger()
{
    _logCts = new CancellationTokenSource();
    Task.Run(() =>
    {
        using var sw = new StreamWriter(logPath, true);
        foreach (var msg in _logQueue.GetConsumingEnumerable(_logCts.Token))
        {
            sw.WriteLine(msg);
            sw.Flush();
        }
    });
}

public void Log(string msg) => _logQueue.Add($"[{DateTime.Now:HH:mm:ss}] {msg}");
```

---

## 11. CSV Parser (Large File)

StreamReader-based, handles NaN and metadata headers.

```csharp
// Header row = Y values, first column = X values, cells = Z values
// Meta: #TITLE,MyData  (lines starting with #)
// Parse: double.TryParse with CultureInfo.InvariantCulture
// NaN: empty cells → double.NaN
```

---

## Pattern Frequency

| Pattern | Usage Count | Priority |
|---------|-------------|----------|
| Timer state machine | 25+ | Critical |
| Access MDB adapter | 15+ | Critical |
| PropertyGrid config | 10+ | High |
| Serial polling | 8+ | High |
| INI file | 8+ | High |
| Sensor reader | 6+ | High |
| LS PLC Cnet | 5+ | High |
| ZedGraph helper | 4+ | Medium |
| CSV parser | 3+ | Medium |
| Log queue | 2+ | Low |
| CrashLogger | 2+ | Low (in template) |

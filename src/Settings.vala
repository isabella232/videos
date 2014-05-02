
public class Audience.Settings : Granite.Services.Settings {
    public bool move_window {get; set;}
    public bool keep_aspect {get; set;}
    public bool resume_videos {get; set;}
    public string[] last_played_videos {get; set;}
    public double last_stopped {get; set;}
    public string last_folder {get; set;}
    public bool playback_wait {get; set;}
    public bool stay_on_top {get; set;}
    public bool show_window_decoration {get; set;}

    public Settings () {
        base ("org.pantheon.Audience");
    }

}
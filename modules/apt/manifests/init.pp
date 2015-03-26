class apt {
    # Run the command
    exec {'apt-get update': }

    # Make Package resources dependant on apt-get update
    Exec['apt-get update'] -> Package <| provider == apt |>
}

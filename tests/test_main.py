from .context import sample


def test_main():
    assert sample.main() == 0, "Should be 0"


if __name__ == "__main__":
    test_main()
    print("Everything passed")

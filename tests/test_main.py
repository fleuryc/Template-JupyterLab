from .context import src


def test_main():
    assert src.main() == 0, "Should be 0"


if __name__ == "__main__":
    test_main()
    print("Everything passed")

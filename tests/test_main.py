from src.main import main


def test_main():
    assert main() == 0, "Should be 0"


if __name__ == "__main__":
    test_main()

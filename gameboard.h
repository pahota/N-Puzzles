#ifndef GAMEBOARD_H
#define GAMEBOARD_H

#include <vector>
#include <QAbstractListModel>
#include <QPoint>

class GameBoard : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(size_t dimension MEMBER m_dimension CONSTANT)
    Q_PROPERTY(int hiddenElementValue READ boardSize CONSTANT FINAL)

public:
    static constexpr size_t defaultPuzzleDimension {4};
    GameBoard(const size_t boardDimension = defaultPuzzleDimension,
              QObject* parent = nullptr);

    struct Tile
    {
        size_t value{};
        QPoint position{};
        Tile& operator=(const size_t newValue)
        {
            value = newValue;
            return *this;
        }
        bool operator==(const size_t other)
        {
            return other == value;
        }
    };

    Q_INVOKABLE bool move(int index);

    int rowCount(const QModelIndex& parent = QModelIndex{}) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    size_t boardSize() const;
    size_t dimension() const;

    std::vector<Tile> rawBoard() const;

    using Position = std::pair<size_t, size_t>;
    Position getRowCol(size_t index) const;

private:
    void shuffle();
    bool isPositionValid(const size_t position) const;
    bool isBoardValid() const;
    void updateTilePositions();

    std::vector<Tile> m_rawBoard;
    const size_t m_dimension;
    const size_t m_boardSize;
};

#endif // GAMEBOARD_H

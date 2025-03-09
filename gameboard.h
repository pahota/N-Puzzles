#ifndef GAMEBOARD_H
#define GAMEBOARD_H

#include <vector>
#include <QAbstractListModel>
#include <QPoint>

class GameBoard : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(size_t dimension READ dimension WRITE setDimension NOTIFY dimensionChanged)
    Q_PROPERTY(int hiddenElementValue READ boardSize NOTIFY boardSizeChanged)
    Q_PROPERTY(int counter READ counter NOTIFY counterChanged)
public:
    GameBoard(QObject* parent = nullptr);

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
    Q_INVOKABLE bool checkWin() const;
    Q_INVOKABLE void setDimension(size_t dimension);
    Q_INVOKABLE void resetBoard();

    int rowCount(const QModelIndex& parent = QModelIndex{}) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    size_t boardSize() const;
    size_t dimension() const;
    int counter() const;

    std::vector<Tile> rawBoard() const;

    using Position = std::pair<size_t, size_t>;
    Position getRowCol(size_t index) const;

signals:
    void dimensionChanged();
    void boardSizeChanged();
    void counterChanged();
    void gameWon();

private:
    void shuffle();
    bool isPositionValid(const size_t position) const;
    bool isBoardValid() const;
    void updateTilePositions();

    std::vector<Tile> m_rawBoard;
    size_t m_dimension{4};
    size_t m_boardSize{m_dimension * m_dimension};
    int m_counter{0};
};

#endif

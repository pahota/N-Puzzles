#include "gameboard.h"
#include <algorithm>
#include <random>
#include <QPoint>

namespace {
bool isAdjacent(const GameBoard::Position f, const GameBoard::Position s) {
    if (f == s)
        return false;
    const auto calcDistance = [](const size_t pos1, size_t pos2) {
        int distance = static_cast<int>(pos1);
        distance -= static_cast<int>(pos2);
        distance = std::abs(distance);
        return distance;
    };
    bool result{false};
    if (f.first == s.first) {
        int distance = calcDistance(f.second, s.second);
        if (distance == 1)
            result = true;
    } else if (f.second == s.second) {
        int distance = calcDistance(f.first, s.first);
        if (distance == 1)
            result = true;
    }
    return result;
}
}

GameBoard::GameBoard(QObject* parent)
    : QAbstractListModel{parent}
{
    resetBoard();
}

void GameBoard::resetBoard() {
    beginResetModel();
    m_boardSize = m_dimension * m_dimension;
    m_rawBoard.resize(m_boardSize);
    for(size_t i = 0; i < m_boardSize; ++i) {
        m_rawBoard[i].value = i + 1;
    }
    m_counter = 0;
    shuffle();
    updateTilePositions();
    endResetModel();
    emit counterChanged();
    emit boardSizeChanged();
}

void GameBoard::setDimension(size_t dimension) {
    if (m_dimension != dimension) {
        m_dimension = dimension;
        resetBoard();
        emit dimensionChanged();
    }
}

bool GameBoard::move(int index) {
    if (!isPositionValid(static_cast<size_t>(index)))
        return false;

    const Position elementPosition{getRowCol(index)};

    auto hiddenElementIterator = std::find_if(m_rawBoard.begin(), m_rawBoard.end(),
                                              [this](const Tile& tile) { return tile.value == boardSize(); });
    Q_ASSERT(hiddenElementIterator != m_rawBoard.end());

    Position hiddenElementPosition{getRowCol(std::distance(m_rawBoard.begin(), hiddenElementIterator))};

    if (!isAdjacent(elementPosition, hiddenElementPosition))
        return false;

    std::swap(hiddenElementIterator->value, m_rawBoard[index].value);
    updateTilePositions();
    m_counter++;
    emit counterChanged();
    emit dataChanged(createIndex(0, 0), createIndex(m_boardSize - 1, 0));

    if (checkWin()) {
        emit gameWon();
    }

    return true;
}

bool GameBoard::checkWin() const {
    for(size_t i = 0; i < m_boardSize - 1; ++i) {
        if(m_rawBoard[i].value != i + 1) {
            return false;
        }
    }
    return m_rawBoard[m_boardSize - 1].value == m_boardSize;
}

int GameBoard::rowCount(const QModelIndex& parent) const {
    Q_UNUSED(parent)
    return m_rawBoard.size();
}

QVariant GameBoard::data(const QModelIndex& index, int role) const {
    if (!index.isValid() || (role != Qt::DisplayRole && role != Qt::UserRole)) {
        return {};
    }

    const int rowIndex{index.row()};

    if (!isPositionValid(rowIndex))
        return {};

    const Tile& tile = m_rawBoard[rowIndex];
    if (role == Qt::DisplayRole) {
        return QVariant::fromValue(tile.value);
    } else if (role == Qt::UserRole) {
        return QVariant::fromValue(tile.position);
    }

    return {};
}

void GameBoard::shuffle() {
    static auto seed = std::chrono::system_clock::now().time_since_epoch().count();
    static std::mt19937 generator(seed);

    do {
        std::shuffle(m_rawBoard.begin(), m_rawBoard.end(), generator);
    } while (!isBoardValid());
}

bool GameBoard::isPositionValid(const size_t position) const {
    return position < m_boardSize;
}

bool GameBoard::isBoardValid() const {
    int inv{0};
    std::vector<size_t> values;

    for (size_t i = 0; i < m_boardSize; ++i) {
        if (m_rawBoard[i].value != m_boardSize) {
            values.push_back(m_rawBoard[i].value);
        }
    }

    for (size_t i = 0; i < values.size(); ++i) {
        for (size_t j = i + 1; j < values.size(); ++j) {
            if (values[i] > values[j]) {
                ++inv;
            }
        }
    }

    size_t emptyPos = 0;
    for (size_t i = 0; i < m_boardSize; ++i) {
        if (m_rawBoard[i].value == m_boardSize) {
            emptyPos = i;
            break;
        }
    }

    size_t emptyRow = emptyPos / m_dimension;

    if (m_dimension % 2 == 1) {
        return (inv % 2 == 0);
    } else {
        return ((inv + emptyRow) % 2 == 1);
    }
}

size_t GameBoard::boardSize() const {
    return m_boardSize;
}

size_t GameBoard::dimension() const {
    return m_dimension;
}

int GameBoard::counter() const {
    return m_counter;
}

std::vector<GameBoard::Tile> GameBoard::rawBoard() const {
    return m_rawBoard;
}

GameBoard::Position GameBoard::getRowCol(const size_t index) const {
    Q_ASSERT(m_dimension > 0);
    size_t row = index / m_dimension;
    size_t column = index % m_dimension;
    return std::make_pair(row, column);
}

void GameBoard::updateTilePositions() {
    for (size_t i = 0; i < m_boardSize; ++i) {
        Position pos = getRowCol(i);
        m_rawBoard[i].position = QPoint(pos.second, pos.first);
    }
}
